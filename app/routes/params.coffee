app.param ':user', (req, res, next, id) ->
  User.find id, (err, user) ->
    return next(err) if err?.status = 404
    req.user = user
    next()

app.param ':config', (req, res, next, id) ->
  SiteConfig.find id, (err, config) ->
    return next(err) if err?.status = 500
    req.site_config = config
    next()
