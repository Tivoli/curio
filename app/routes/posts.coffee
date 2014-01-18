exports.create = (req, res, next) ->
  req.resource = new Post(req.body).set_user(req.session.user.id)
  utils.save_and_send(req, res, next)
