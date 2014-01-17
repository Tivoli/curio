exports.index = (req, res, next) ->
  cursor = User.sorted(req.query.page, req.query.limit)
  utils.streamJSON(req, res, next, cursor)

exports.create = (req, res, next) ->
  new User(req.body).validate (err, user) ->
    return next(err) if err?.status = 400
    user.set_self().save (err, user) ->
      return next(err) if err?.status = 400
      json = req.session.user = user.toJSON()
      res.json json

exports.me = (req, res, next) ->
  res.json req.session.user

exports.read = (req, res, next) ->
  res.format
    html: -> res.render('users/show')
    json: -> res.json(req.user.toJSON())

exports.update = (req, res, next) ->
  req.user.set_self().whitelist(req.body).validate (err, user) ->
    return next(err) if err?.status = 400
    user.save (err, user) ->
      return next(err) if err?.status = 500
      json = req.session.user = user.toJSON()
      res.json(json)

exports.destroy = (req, res, next) ->

exports.resetpassword = (req, res, next) ->
  unless _(req.body.email).isEmail()
    err = new Error('Missing or Invalid Email') ; err.status = 400
    return next(err)
  User.find req.body.email, (err, user) ->
    return next(err) if err?.status = 400
    token = "#{utils.randomString(24)}.#{user.id()}"
    app.redis.set "reset:#{token}", user.id(), 'NX', 'EX', 172800, (err, obj) ->
      return next(err) if err?.status = 500
      res.send 200
