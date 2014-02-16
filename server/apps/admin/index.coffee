express = require('express')
app     = express()

module.exports = (core) ->
  app.set 'views', "#{__dirname}/views"
  app.set 'middleware', core.get('middleware')

  if app.get('env') is 'development'
    app.use express.logger('dev')
    app.use require('connect-assets')(paths: core.get('assets'))
  else
    app.use require('connect-assets')(paths: core.get('assets'), build: true)

  require('./locals')(app, core)
  require('./routes')(app)
  return app
