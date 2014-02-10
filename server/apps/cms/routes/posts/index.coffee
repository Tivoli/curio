routes = require('./routes')

module.exports = (app, mw) ->
  app.get '/posts', routes.index
