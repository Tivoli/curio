routes = require('./routes')

module.exports = (app, mw) ->
  app.get '/', routes.index
