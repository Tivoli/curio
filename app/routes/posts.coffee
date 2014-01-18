exports.create = (req, res, next) ->
  post = new Post(req.body).set_user(req.session.user.id)
  utils.save_and_send(req, res, next, post)

exports.read = (req, res, next) ->
  res.format
    html: -> res.render('posts/show')
    json: -> res.json(req.post.toJSON())

exports.update = (req, res, next) ->
  utils.save_and_send(req, res, next, req.post)

exports.destroy = (req, res, next) ->
  req.post.destroy ->
    return next(err) if err?.status = 500
    res.send(200)
