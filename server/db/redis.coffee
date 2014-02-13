redis   = require('redis')

module.exports = (app) ->
  config    = app.get('redis_config')
  client    = redis.createClient(config.port, config.host)
  app.redis = client
  client.select(config.db)
