bcrypt  = require('bcrypt')
blocked = require '../data/reserved'
blocked.push(fleck.pluralize(k)) for k in blocked

class global.User extends Model
  @collection: app.mongo.users

  @find_by_auth: (source, uid, fn) ->
    query =
      'authentications.source': source
      'authentications.uid': uid
    @collection.findOne query, (err, data) ->
      return fn(err or new Error('User Not Found')) unless data?
      new User(data).populate(fn)

  allowed: ['email', 'username', 'password', 'name']

  email:            -> @model?.email
  username:         -> @model?.username_original or @model?.username
  password:         -> @model?.password
  name:             -> @model?.name
  avatar:           -> @model?.avatar
  settings:         -> @model?.settings
  authentications:  -> @model?.authentications
  is_admin:         -> 'admin' in (@model?.roles or [])
  first_name:       -> @name().split(' ')[0]
  last_name:        -> _(@name().split(' ')).rest().join(' ')

  defaults: ->
    _(@model).defaults
      settings: {}
      authentications: []

  set_self: ->
    @is_self = true
    return this

  validate: (fn) ->
    unless @_id()?
      return fn(new Error('Missing Email')) unless @email()?
      return fn(new Error('Missing Name')) unless @name()?
      return fn(new Error('Missing Password')) unless @password()?
    return fn(new Error('Invalid Email')) unless _.isEmail(@email())
    return fn(new Error('Invalid Name')) unless _.isName(@name())
    return fn(new Error('Invalid Username')) unless _.isUsername(@username())
    return fn(new Error('Invalid Username')) if @username() in blocked
    return fn(new Error('Password too short')) if @password()?.length < 6
    return fn(null, this) unless @password()?
    @hash_password(fn)

  whitelist: (values) ->
    updates = _.pick(values, @allowed)
    updates.email = updates.email.toLowerCase() if updates.email?
    updates.username ?= utils.randomString(12)
    if updates.username?
      updates.username_original = updates.username
      updates.username          = updates.username.toLowerCase()
    @set(updates)

  hash_password: (fn) ->
    bcrypt.hash @password(), 10, (err, hash) =>
      return fn(err) if err?
      @set(hashed_password: hash)
      fn(null, this)

  authenticate: (pass, fn) ->
    return fn(new Error('Invalid Password')) unless @model.hashed_password?
    bcrypt.compare pass, @model.hashed_password, (err, result) =>
      return fn(err) if err?
      return fn(new Error('Invalid Password')) unless result
      fn(null, this)

  add_role: (role, fn) ->
    @update {$addToSet: {roles: role}}, fn

  remove_role: (role, fn) ->
    @update {$pull: {roles: role}}, fn

  save: (fn) ->
    delete @model.password
    super(fn)

  toJSON: (show_email) ->
    id:       @id()
    username: @username()
    name:     @name()
    avatar:   @avatar()
    is_admin: @is_admin()
    email:    @email() if show_email or @is_self
