routes  = require('./routes')

module.exports = (app, mw) ->
  app.get '/uploads/cors', mw.restricted, routes.cors
  app.get '/uploads/*', routes.read
