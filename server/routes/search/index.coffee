routes  = require('./routes')

module.exports = (mw) ->
  app.get '/search', routes.index
