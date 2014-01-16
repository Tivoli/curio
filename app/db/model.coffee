class global.Model
  @strToID: (id) -> app.mongo.stringToID(id)

  @find: (id, fn) ->
    query = {$or: []}
    query.$or.push({_id: @strToID(id)}) if _(id).isObjectID()
    query.$or.push({slug: id.toLowerCase()}) if _(id.toLowerCase?()).isSlug()
    query.$or.push({email: id.toLowerCase()}) if _(id.toLowerCase?()).isEmail()
    query.$or.push({username: id.toLowerCase()}) if _(id.toLowerCase?()).isUsername()
    return fn(new Error("Missing query param for #{@name}")) unless query.$or.length
    @collection.findOne query, (err, data) =>
      return fn(err or new Error("Cannot find #{@name}")) unless data?
      new global[@name](data).populate(fn)

  @paginated: (page=1, limit=20) ->
    opts =
      skip: (+page - 1) * limit
      limit: limit
    @collection.find({}, opts)

  constructor: (@model={}) ->
    @strToID    = Model.strToID
    @collection = @constructor.collection
    _(this).bindAll('populate_images')
    unless @_id()?
      @model = _.pick(@model, @allowed) if @allowed?
      @whitelist?(@model)
      @defaults?()
    return this

  _id:        -> @model?._id
  _user:      -> @model?._user
  id:         -> @model?._id?.toHexString()
  slug:       -> @model?.slug
  created_at: -> new Date(@_id().getTimestamp()).toISOString()

  set: (values={}) ->
    @model ?= {}
    @model[key] = val for key, val of values
    return this

  populate_images: (fn) ->
    images = []
    stream = app.mongo.fs_files.find({'metadata._id': @_id()}).stream()
    stream.on 'data', (item) -> images.push(new Image(item).toJSON())
    stream.on 'close', -> fn(null, images)

  populate: (fn) ->
    funcs = {}
    funcs.images = @populate_images
    async.parallel funcs, (err, results) =>
      return fn(err) if err?
      @images = results.images or []
      fn(null, this)

  save: (fn) ->
    @collection.save @model, {safe: true}, (err, model) =>
      if err? and /^E11000 duplicate key/.test(err.message)
        key = _(/\$(.*?)_/.exec(err.message)).last()
        err = new Error("Duplicate #{fleck.capitalize(key)}")
      return fn?(err) if err?
      fn?(null, this)

  update: (query, fn) ->
    @collection.findAndModify {_id: @_id()}, [], query, {new: true}, (err, model) =>
      return fn?(err) if err?
      @model = model
      fn?(null, this)

  destroy: (fn) ->
    @collection.remove {_id: @_id()}, (err, model) =>
      fn?(err, this)
