exports.index = (req, res, next) ->
  utils.streamJSON(req, res, next, User.sorted())

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
    json: -> utils.sendJSON(req, res, req.user)

exports.update = (req, res, next) ->
  method = if req.body.is_admin then 'add_role' else 'remove_role'
  req.user[method] 'admin', (err, user) ->
    return next(err) if err?
    res.json user.toJSON()

exports.destroy = (req, res, next) ->

exports.resetpassword = (req, res, next) ->
  unless req.body.email? and _.isEmail(req.body.email)
    err = new Error('Missing or Invalid Email') ; err.status = 400
    return next(err)
  User.find req.body.email, (err, user) ->
    return next(err) if err?.status = 400
    token = "#{utils.randomString(24)}.#{user.id()}"
    app.redis.set "reset:#{token}", user.id(), 'NX', 'EX', 172800, (err, obj) ->
      return next(err) if err?.status = 500
      res.send 200
