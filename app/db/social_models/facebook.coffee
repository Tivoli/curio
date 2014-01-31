qs      = require('querystring')
config  = app.get('facebook_config')

class global.Facebook extends SocialModel

  validate: (fn) ->
    return fn(new BadRequest('Missing UID')) unless @uid()?
    return fn(new BadRequest('Missing Token')) unless @token()?
    fn(null, this)

  access_token: (fn) ->
    opts =
      url: "#{config.url}/oauth/access_token"
      qs:
        client_id:          config.app_id
        client_secret:      config.app_secret
        grant_type:         'fb_exchange_token'
        fb_exchange_token:  @token()
    request.get opts, (err, r, body) ->
      return fn(err) if err?
      token = qs.parse(body).access_token
      return fn(new BadRequest('Missing token')) unless token?
      fn(null, token)

  fetch: (fn) ->
    request.get "#{config.url}/me?access_token=#{@token()}", (e, r, body) =>
      return fn(new BadRequest(body)) unless r?.statusCode is 200
      @model.uid       = body.id.toString()
      @model.name      = body.name
      @model.username  = body.username
      @model.avatar    = "#{config.url}/#{@uid()}/picture?type=large"
      @model.email     = body.email
      @model.gender    = body.gender
      fn(null, this)

  create_user: (fn) ->
    username = switch true
      when @username()? then @username()
      else @name().replace(/\s/g,'.').substr(0,15)

    data =
      name:     @name()
      username: username
      email:    @email()
      password: utils.randomString()
    new User(data).save (err, user) =>
      return fn(err) if err?
      @user = user
      fn(null, this)
