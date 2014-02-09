routes  = require('./routes')

module.exports = (app, mw) ->
  app.param ':source', (req, res, next, source) ->
    model = global[fleck.capitalize(source)]
    new model(req.body).validate (err, source) ->
      return next(err) if err?
      req.source = source
      next()

  app.post '/oauth/:source', routes.create
