redis   = require('redis')

module.exports = (app) ->
  config    = app.get('redis_config')
  app.redis = redis.createClient(config.port, config.host)
  app.redis.select(config.db)
