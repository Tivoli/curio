module.exports = (app, mw) ->
  app.get '/pages', mw.render_index
