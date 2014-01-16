exports.load_locals = (req, res, next) ->
  return next() if app.locals.website?
  SiteConfig.find 'website', (err, config) ->
    return next() if err?
    app.locals.website = config.toJSON()
    next()

exports.authed = (req, res, next) ->
  return next() if req.session?.user?
  res.format
    html: -> res.redirect('/')
    json: -> res.send(401)

exports.restricted = (req, res, next) ->
  return next() if req.session?.user?.is_admin
  res.format
    html: -> res.redirect('/')
    json: -> res.send(401)
