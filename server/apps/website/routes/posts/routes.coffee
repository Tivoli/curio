exports.index = (req, res, next) ->
  cursor = Post.sorted(req.param('page'), req.param('limit'))
  utils.streamJSON(req, res, next, cursor)

exports.create = (req, res, next) ->
  req.resource = new Post(req.body).set_user(req.session.user.id)
  utils.save_and_send(req, res, next)
