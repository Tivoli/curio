exports.read = (req, res, next) ->
  res.json req.site_config.toJSON()

exports.update = (req, res, next) ->
  req.site_config.whitelist(req.body)
  delete app.locals.website if req.params.config is 'website'
  utils.save_and_send(req, res, next, req.site_config)
