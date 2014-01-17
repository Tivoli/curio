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

  @find_by_token: (token, fn) ->
    return fn(new Error('Missing Token')) unless token? and _(token).isString()
    app.redis.get "reset:#{token}", (err, uid) ->
      return fn(err or new Error('Invalid Token')) unless uid?
      User.find(uid, fn)

  @authenticate: (email, pass, fn) ->
    return fn(new Error('Invalid Email')) unless _(email).isEmail()
    return fn(new Error('Missing Password')) unless _(pass).isString() and pass.length
    @find email, (err, user) ->
      return fn(err) if err?
      user.set_self().match_password(pass, fn)

  allowed: ['email', 'username', 'password', 'name']

  email:            -> @model?.email
  username:         -> @model?.username_original or @model?.username
  password:         -> @model?.password
  name:             -> @model?.name
  avatar:           -> @model?.avatar
  settings:         -> @model?.settings
  authentications:  -> @model?.authentications
  hashed_password:  -> @model?.hashed_password
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
    return fn(new Error('Invalid Email')) unless _(@email()).isEmail()
    return fn(new Error('Invalid Name')) unless _(@name()).isName()
    return fn(new Error('Invalid Username')) unless _(@username()).isUsername()
    return fn(new Error('Invalid Username')) if @username() in blocked
    return fn(new Error('Password too short')) if @password()?.length < 6
    return fn(null, this) unless @password()?
    @hash_password(fn)

  whitelist: (values) ->
    updates = _(values).pick(@allowed)
    updates.email = updates.email.toLowerCase() if updates.email?
    if updates.username?
      updates.username_original = updates.username
      updates.username          = updates.username.toLowerCase()
    @set(updates)

  hash_password: (fn) ->
    bcrypt.hash @password(), 10, (err, hash) =>
      return fn(err) if err?
      @set(hashed_password: hash)
      fn(null, this)

  match_password: (pass, fn) ->
    bcrypt.compare pass, @hashed_password(), (err, result) =>
      return fn(err or new Error('Invalid Password')) unless result
      fn(null, this)

  add_role: (role, fn) ->
    @update {$addToSet: {roles: role}}, fn

  remove_role: (role, fn) ->
    @update {$pull: {roles: role}}, fn

  save: (fn) ->
    delete @model.password
    super(fn)

  toJSON: ->
    json =
      id:       @id()
      username: @username()
      name:     @name()
      avatar:   @avatar()
      is_admin: @is_admin()
    if @is_self
      _(json).extend
        email:            @email()
        settings:         @settings()
        authentications:  @authentications()
    return json
