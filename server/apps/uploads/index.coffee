express = require('express')
app     = express()

module.exports = (core) ->
  app.set('aws_config', core.get('aws_config'))

  require('./routes')(app, core.mw)

  return app
