exports.load_locals = (req, res, next) ->
  return next() if app.locals.website?
  SiteConfig.find 'website', (err, config) ->
    return next() if err?
    app.locals.website = config.toJSON()
    next()

exports.authed = (req, res, next) ->
  return next() if req.session?.user?
  next(new Unauthorized)

exports.private = (req, res, next) ->
  return next() if req.session?.user?.id is req.resource.id()
  next(new Unauthorized)

exports.restricted = (req, res, next) ->
  return next() if req.session?.user?.is_admin
  next(new Unauthorized)

exports.read = (req, res) ->
  name = req.resource.constructor.name
  root = fleck.pluralize(name).toLowerCase()
  json = req.resource.toJSON()
  res.format
    html: -> res.render("templates/#{root}/show", json)
    json: -> res.json(json)

exports.destroy = (req, res, next) ->
  req.resource.destroy (err) ->
    return next(err) if err
    res.send(200)
