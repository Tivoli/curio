bugsnag = require('bugsnag')

module.exports = (app) ->
  module = {}
  bugsnag.register(app.get('bugsnag_config').key)

  module.authed = (req, res, next) ->
    return next() if req.session?.user?
    next(new Unauthorized)

  module.private = (req, res, next) ->
    return next() if req.session?.user?.id is req.resource.id()
    next(new Unauthorized)

  module.restricted = (req, res, next) ->
    return next() if req.session?.user?.is_admin
    next(new Unauthorized)

  module.read = (req, res) ->
    name = req.resource.constructor.name
    root = fleck.pluralize(name).toLowerCase()
    json = req.resource.toJSON()
    res.format
      html: -> res.render("templates/#{root}/show", json)
      json: -> res.json(json)

  module.get_index = (req, res, next) ->
    return next() unless utils.is_json_request(req)
    model   = utils.to_model(req.route.path.slice(1))
    cursor  = model.paginated(req.param('page'), req.param('limit'))
    utils.streamJSON(req, res, next, cursor)

  module.destroy = (req, res, next) ->
    req.resource.destroy (err) ->
      return next(err) if err
      res.send(200)

  module.error = (err, req, res, next) ->
    if not err.statusCode? or /^5\d+/.test(err.statusCode)
      bugsnag.notify(err) unless app.get('env') is 'test'
    res.format
      html: ->
        return res.redirect('/') if err.statusCode is 401
        res.status(err.statusCode or 500).render("error", {url: req.url, error: err.message})
      json: -> res.json(err.statusCode or 500, {url: req.url, error: err.message})

  return module
