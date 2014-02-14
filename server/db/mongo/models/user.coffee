bcrypt  = require('bcrypt')
blocked = require('../data/reserved')
blocked.push(fleck.pluralize(k)) for k in blocked

module.exports = (app) ->
  mongo = app.mongo
  redis = app.redis

  class global.User extends Model
    @collection: mongo.users

    @find_by_auth: (source, uid, fn) ->
      query =
        'authentications.source': source
        'authentications.uid': uid
      @collection.findOne query, (err, data) ->
        return fn(err or new NotFound('User Not Found')) unless data?
        new User(data).populate(fn)

    @find_by_token: (token, fn) ->
      return fn(new Unauthorized) unless token? and _(token).isString()
      app.redis.get "reset:#{token}", (err, uid) ->
        return fn(err or new Unauthorized) unless uid?
        User.find(uid, fn)

    @authenticate: (email, pass, fn) ->
      return fn(new Unauthorized) unless _(email).isEmail()
      return fn(new Unauthorized) unless _(pass).isString() and pass.length
      @find email, (err, user) ->
        return fn(err) if err?
        user.set_self().match_password(pass, fn)

    @sorted: (page, limit) ->
      @paginated(page, limit).sort('email', 'asc')

    whitelist: ['email', 'username', 'password', 'name']

    email:            -> @model.email
    username:         -> @model.username_original or @model.username
    password:         -> @model.password
    name:             -> @model.name
    avatar:           -> @model.avatar
    settings:         -> @model.settings
    authentications:  -> @model.authentications
    hashed_password:  -> @model.hashed_password
    is_admin:         -> 'admin' in (@model?.roles or [])

    defaults: ->
      _(@model).defaults
        settings: {}
        authentications: []

    set_self: ->
      @is_self = true
      return this

    validate: (fn) ->
      unless @_id()?
        return fn(new BadRequest('Missing Email')) unless @email()?
        return fn(new BadRequest('Missing Name')) unless @name()?
        return fn(new BadRequest('Missing Password')) unless @password()?
      return fn(new BadRequest('Invalid Email')) unless _(@email()).isEmail()
      return fn(new BadRequest('Invalid Name')) unless _(@name()).isName()
      return fn(new BadRequest('Invalid Username')) unless _(@username()).isUsername()
      return fn(new BadRequest('Invalid Username')) if @username() in blocked
      return fn(new BadRequest('Password too short')) if @password()?.length < 6
      return fn(null, this) unless @password()?
      @hash_password(fn)

    amend: (values) ->
      super(values)
      @set({
        email: values.email?.toLowerCase()
        username: values.username?.toLowerCase()
        username_original: values.username
      })

    hash_password: (fn) ->
      bcrypt.hash @password(), 10, (err, hash) =>
        return fn(err) if err?
        @set(hashed_password: hash)
        fn(null, this)

    match_password: (pass, fn) ->
      bcrypt.compare pass, @hashed_password(), (err, result) =>
        return fn(err or new Unauthorized('Invalid Password')) unless result
        fn(null, this)

    update_role: (method, role, fn) ->
      return fn(new BadRequest('Missing Role')) unless _(role).isString()
      query = switch method
        when 'add' then {$addToSet: {roles: role}}
        else {$pull: {roles: role}}
      @update(query, fn)

    update_token: (fn) ->
      token = "#{utils.randomString(24)}.#{@id()}"
      redis.set "reset:#{token}", @id(), 'NX', 'EX', 172800, (err, obj) ->
        return fn(new RedisError(err.message)) if err?
        fn(null, obj)

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
