routes  = require('./routes')

module.exports = (app, mw) ->
  app.param ':page', (req, res, next, id) ->
    Page.find id, (err, page) ->
      return next(err) if err?
      req.resource = page
      next()

  app.get '/pages', mw.restricted, mw.get_index
  app.post '/pages', mw.restricted, routes.create
  app.get '/pages/:page', mw.read
  app.put '/pages/:page', mw.restricted, utils.save_and_send
  app.delete '/pages/:page', mw.restricted, mw.destroy
