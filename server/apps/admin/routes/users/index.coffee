module.exports = (app, mw) ->
  app.get '/users', mw.render_index
