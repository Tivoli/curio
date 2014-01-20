exports.create = (req, res, next) ->
  req.resource = new Page(req.body)
  utils.save_and_send(req, res, next)
