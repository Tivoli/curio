EventEmitter = require("events").EventEmitter

class global.Model extends EventEmitter
  @strToID:   (id) -> app.mongo.stringToID(id)
  @dateToID:  (date) -> app.mongo.dateToID(date)

  @find: (id, fn) ->
    query = {$or: []}
    query.$or.push({_id: @strToID(id)}) if _(id).isObjectID()
    query.$or.push({slug: id.toLowerCase()}) if _(id?.toLowerCase?()).isSlug()
    query.$or.push({email: id.toLowerCase()}) if _(id?.toLowerCase?()).isEmail()
    query.$or.push({username: id.toLowerCase()}) if _(id?.toLowerCase?()).isUsername()
    query.$or.push({path: id.toLowerCase()}) if _(id).isString() and @name is 'Page'
    return fn(new BadRequest("Missing query param for #{@name}")) unless query.$or.length
    @collection.findOne query, (err, data) =>
      return fn(err or new NotFound("Cannot find #{@name}")) unless data?
      new global[@name](data).populate(fn)

  @paginated: (page=1, limit=20) ->
    opts =
      skip: (+page - 1) * limit
      limit: limit
    @collection.find({}, opts)

  @search: (query, page=1, limit=20) ->
    opts =
      skip: (+page - 1) * limit
      limit: limit
    @collection.find(query, opts)

  constructor: (@model={}) ->
    @strToID    = Model.strToID
    @dateToID   = Model.dateToID
    @collection = @constructor.collection
    _(this).bindAll('populate_author')
    unless @_id()?
      @model = _.pick(@model, @allowed) if @allowed?
      @defaults?()
    return this

  _id:        -> @model._id
  _user:      -> @model._user
  id:         -> @model._id?.toHexString()
  slug:       -> @model.slug
  created_at: -> new Date(@_id().getTimestamp()).toISOString()

  validate: (fn) ->
    return fn(null, this)

  whitelist: (values) ->
    updates = _(values).pick(@allowed)
    @set(updates)

  set: (values={}) ->
    @model[key] = val for key, val of values
    return this

  set_user: (id) ->
    @set({_user: @strToID(id)})

  populate_author: (fn) ->
    User.find @_user(), fn

  populate: (fn) ->
    funcs = {}
    funcs.author = @populate_author if @_user()?
    async.parallel funcs, (err, results) =>
      return fn(err) if err?
      @author = results.author
      fn(null, this)

  save: (fn) ->
    @collection.save @model, {safe: true}, (err, model) =>
      if err? and /^E11000 duplicate key/.test(err.message)
        key = _(/\$(.*?)_/.exec(err.message)).last()
        err = new BadRequest("Duplicate #{fleck.capitalize(key)}")
      return fn?(err) if err?
      @emit('saved')
      fn?(null, this)

  update: (query, fn) ->
    @collection.findAndModify {_id: @_id()}, [], query, {new: true}, (err, model) =>
      return fn?(err) if err?
      @model = model
      fn?(null, this)

  destroy: (fn) ->
    @collection.remove {_id: @_id()}, (err, model) =>
      fn?(err, this)

fs = require('fs')
for file in fs.readdirSync(__dirname) when "#{__dirname}/#{file}" isnt __filename
  require("./#{file}")
