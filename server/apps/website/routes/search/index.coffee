routes  = require('./routes')

module.exports = (app, mw) ->
  app.get '/search', routes.index
