module.exports = (app) ->

  class global.SocialModel

    constructor: (@model={}) ->
      @model.uid     = @model?.uid?.toString()
      @model.source  = @constructor.name.toLowerCase()
      return this

    uid:      -> @model?.uid
    token:    -> @model?.token
    secret:   -> @model?.secret
    name:     -> @model?.name
    avatar:   -> @model?.avatar
    email:    -> @model?.email
    gender:   -> @model?.gender
    source:   -> @model?.source
    username: -> @model?.username

    find_or_create_user: (fn) ->
      User.find_by_auth @source(), @uid(), (err, user) =>
        @user = user
        return fn(null, this) if @user?
        @fetch (err, self) =>
          return fn(new NotFound('Cannot find user')) unless @email()?
          User.find @email(), (err, user) =>
            @user = user
            return fn(null, this) if @user?
            @create_user(fn)

    update_user: (fn) ->
      @fetch (err, model) =>
        return fn(err) if err?
        current = _(@user.authentications()).reject (a) => a.source is @source()
        current.push @model
        updates         = authentications: current
        updates.name    = @name() unless @user.name()?
        updates.avatar  = @avatar() unless @user.model.avatar?
        updates.gender  = @gender() if @gender()?
        unless @user.settings()["share_#{@source()}"]
          updates.settings = @user.settings()
          updates.settings["share_#{@source()}"] = 0
        @user.set(updates).save (err, user) =>
          return fn(err) if err?
          @user = user
          fn(null, this)
