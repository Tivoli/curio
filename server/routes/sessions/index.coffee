routes  = require('./routes')

module.exports = (mw) ->
  app.post '/sessions', routes.create
  app.get '/sessions/token', routes.token
  app.get '/logout', mw.authed, routes.destroy
