routes  = require('./routes')

module.exports = (mw) ->
  app.param ':user', (req, res, next, id) ->
    User.find id, (err, user) ->
      return next(err) if err?
      req.resource = user
      req.resource.set_self() if req.resource.id() is req.session?.user?.id
      next()

  app.get '/users', mw.restricted, routes.index
  app.post '/users', routes.create
  app.get '/users/me', mw.authed, routes.me
  app.post '/users/resetpassword', routes.resetpassword
  app.get '/users/:user', mw.read
  app.put '/users/:user', mw.private, routes.update
  app.all '/users/:user/roles', mw.restricted, routes.update_role
