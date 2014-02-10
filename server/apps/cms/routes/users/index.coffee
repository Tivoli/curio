routes = require('./routes')

module.exports = (app, mw) ->
  app.get '/users', routes.index
