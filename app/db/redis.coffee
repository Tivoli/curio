redis   = require('redis')
config  = app.get('redis_config')
client  = redis.createClient(config.port, config.host)

client.select(config.db)
app.redis = client
