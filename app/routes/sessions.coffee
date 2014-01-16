exports.create = (req, res, next) ->
  return next() if req.session?.user?
  unless _.isEmail(req.body.email) and req.body.password?
    err = new Error('Invalid or Missing Username or Password')
    err.status = 401
    return next(err)
  User.find req.body.email, (err, user) ->
    return next(err) if err?.status = 404
    user.authenticate req.body.password, (err, user) ->
      return next(err) if err?.status = 401
      json = req.session.user = user.set_self().toJSON()
      res.json json

exports.destroy = (req, res) ->
  req.session.destroy ->
    res.redirect req.get('referer')

exports.token = (req, res, next) ->
  unless req.query.token?
    err = new Error('Missing Token')
    err.status = 401
    return next(err)
  app.redis.get "reset:#{req.query.token}", (err, uid) ->
    return next(err) if err?.status = 500
    unless uid?
      err = new Error('Invalid Token')
      err.status = 401
      return next(err)
    User.find uid, (err, user) ->
      return next(err) if err?.status = 500
      json = req.session.user = user.set_self().toJSON()
      res.redirect '/'
