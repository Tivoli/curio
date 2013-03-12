redis         = require('redis')
cookie        = require('cookie')
socketio      = require('socket.io')
redis_config  = app.get('redis_config')

module.exports = (server) ->
  io    = socketio.listen(server)
  pub   = redis.createClient(redis_config.port, redis_config.host)
  sub   = redis.createClient(redis_config.port, redis_config.host)
  store = redis.createClient(redis_config.port, redis_config.host)

  io.configure ->
    io.set('store', new socketio.RedisStore({redisPub: pub, redisSub: sub, redisClient: store}))
    io.set('match origin protocol', true)
    io.enable('browser client minification')
    io.enable('browser client etag')
    io.enable('browser client gzip')
    io.set('log level', 0)
    io.set('polling duration', 10)
    io.set('transports', ['websocket', 'flashsocket', 'htmlfile', 'xhr-polling', 'jsonp-polling'])

  io.configure 'development', ->
    io.set('log level', 1)

  io.of('/api')
    .authorization((data, fn) ->
      return fn(null, true) unless data?.headers?.cookie?
      sessionID = cookie.parse(data.headers.cookie)['connect.sid']
      data.sid  = sessionID?.match(/.?:(.*)\./)[1]
      fn(null, true)
    ).on('connection', (socket) ->
      sid  = socket.handshake.sid
      app.sessionStore.get sid, (err, session) ->
        console.log("#{session.user?.username} Connected to API #{socket.id}") if /dev/.test(app.get('env'))
        socket.emit 'ready', session?.user
    )

