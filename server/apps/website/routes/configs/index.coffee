module.exports = (app, mw) ->
  app.param ':config', (req, res, next, id) ->
    SiteConfig.find id, (err, config) ->
      return next(err) if err?
      req.resource = config
      next()

  routes = require('./routes')(app)

  app.all '/configs*', mw.restricted
  app.get '/configs/:config', mw.read
  app.put '/configs/:config', routes.update
