routes  = require('./routes')

module.exports = (mw) ->
  app.get '/templates/:templates', routes.read
