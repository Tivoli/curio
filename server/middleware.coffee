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

exports.get_index = (req, res, next) ->
  return next() unless utils.is_json_request(req)
  model   = app.mongo.getModel(req.route.path.slice(1))
  cursor  = model.sorted_name(req.param('page'), req.param('limit'))
  utils.streamJSON(req, res, next, cursor)

exports.destroy = (req, res, next) ->
  req.resource.destroy (err) ->
    return next(err) if err
    res.send(200)

exports.error = (err, req, res, next) ->
  res.format
    html: ->
      return res.redirect('/') if err.statusCode is 401
      res.status(err.statusCode or 500).render("error", {url: req.url, error: err.message})
    json: -> res.json(err.statusCode or 500, {url: req.url, error: err.message})
