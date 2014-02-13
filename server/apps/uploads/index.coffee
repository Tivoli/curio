express = require('express')
app     = express()

module.exports = (core) ->
  app.set 'aws_config', core.get('aws_config')
  app.set 'middleware', core.get('middleware')

  require('./routes')(app)

  return app
