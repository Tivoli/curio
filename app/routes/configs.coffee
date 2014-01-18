exports.read = (req, res, next) ->
  res.json req.site_config.toJSON()

exports.update = (req, res, next) ->
  delete app.locals.website if req.params.config is 'website'
  utils.save_and_send(req, res, next)
