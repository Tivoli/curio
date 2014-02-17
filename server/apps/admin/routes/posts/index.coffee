module.exports = (app, mw) ->
  app.get '/posts', mw.render_index
