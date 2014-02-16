routes = require('./routes')

module.exports = (app, mw) ->
  app.get '/settings', routes.index
