exports.index = (req, res, next) ->
  cursor = User.sorted(req.query.page, req.query.limit)
  utils.streamJSON(req, res, next, cursor)

exports.create = (req, res, next) ->
  req.resource = new User(req.body).set_self()
  req.resource.once 'saved', ->
    req.session.user = req.resource.toJSON()
  utils.save_and_send(req, res, next)

exports.me = (req, res, next) ->
  res.json req.session.user

exports.update = (req, res, next) ->
  req.resource.once 'saved', ->
    req.session.user = req.resource.toJSON()
  utils.save_and_send(req, res, next)

exports.resetpassword = (req, res, next) ->
  unless _(req.body.email).isEmail()
    return next(new BadRequest('Missing or Invalid Email'))
  User.find req.body.email, (err, user) ->
    return next(err) if err?
    token = "#{utils.randomString(24)}.#{user.id()}"
    app.redis.set "reset:#{token}", user.id(), 'NX', 'EX', 172800, (err, obj) ->
      return next(err) if err?
      res.send 200

exports.update_role = (req, res, next) ->
  method = if req.method is 'POST' then 'add' else 'remove'
  req.resource.update_role method, req.body.role, (err, user) ->
    return next(err) if err?
    res.json(user.toJSON())
