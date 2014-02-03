routes = require('./routes')

module.exports = (mw) ->
  app.get '/channel.html', routes.channel
  app.get '/', routes.index
