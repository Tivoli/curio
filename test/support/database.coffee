module.exports = (app) ->
  module  = {}
  mongo   = app.mongo
  redis   = app.redis

  empty_db = (done) ->
    mongo.db.collections (err, collections) ->
      async.each collections, ((c, fn) ->
        return fn() if /^system/.test(c.collectionName)
        c.remove({}, {safe: true}, fn)
      ), done

  module.connect = (done) ->
    do connect = ->
      return done() if mongo.db?.state is 'connected'
      setTimeout connect, 5

  module.clear = (done) ->
    async.parallel
      redis: (fn) -> redis.flushdb(fn)
      mongo: (fn) -> empty_db(fn)
    , done

  module.seed     = mongo.seed
  module.seed_dir = mongo.seed_dir

  return module
