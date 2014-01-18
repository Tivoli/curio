exports.load_locals = (req, res, next) ->
  return next() if app.locals.website?
  SiteConfig.find 'website', (err, config) ->
    return next() if err?
    app.locals.website = config.toJSON()
    next()

exports.authed = (req, res, next) ->
  return next() if req.session?.user?
  err = new Error('Unauthorized') ; err.status = 401
  next(err)

exports.private = (req, res, next) ->
  return next() if req.session?.user?.id is req.resource.id()
  err = new Error('Unauthorized') ; err.status = 401
  next(err)

exports.restricted = (req, res, next) ->
  return next() if req.session?.user?.is_admin
  err = new Error('Unauthorized') ; err.status = 401
  next(err)

exports.read = (req, res) ->
  name = req.resource.constructor.name
  root = fleck.pluralize(name).toLowerCase()
  res.format
    html: -> res.render("#{root}/show")
    json: -> res.json(req.resource.toJSON())

exports.destroy = (req, res, next) ->
  req.resource.destroy ->
    return next(err) if err?.status = 500
    res.send(200)
