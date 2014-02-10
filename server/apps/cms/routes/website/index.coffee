routes = require('./routes')

module.exports = (app, mw) ->
  app.get '/website', routes.index
