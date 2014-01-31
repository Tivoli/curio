exports.create = (req, res, next) ->
  return next() if req.session?.user?
  User.authenticate req.body.email, req.body.password, (err, user) ->
    return next(err) if err?
    json = req.session.user = user.toJSON()
    res.json(json)

exports.destroy = (req, res) ->
  req.session.destroy ->
    res.redirect req.get('referer')

exports.token = (req, res, next) ->
  User.find_by_token req.query.token, (err, user) ->
    return next(err) if err?
    req.session.user = user.set_self().toJSON()
    res.redirect('/')
