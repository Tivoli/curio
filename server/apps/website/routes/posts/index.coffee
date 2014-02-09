routes  = require('./routes')

module.exports = (app, mw) ->
  app.param ':post', (req, res, next, id) ->
    Post.find id, (err, post) ->
      return next(err) if err?
      req.resource = post
      next()

  app.get '/posts', routes.index
  app.post '/posts', mw.restricted, routes.create
  app.get '/posts/:post', mw.read
  app.put '/posts/:post', mw.restricted, utils.save_and_send
  app.delete '/posts/:post', mw.restricted, mw.destroy
