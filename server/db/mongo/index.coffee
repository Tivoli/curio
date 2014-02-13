mongodb     = require('mongodb')
MongoClient = mongodb.MongoClient
ObjectID    = mongodb.ObjectID

module.exports = (app) ->
  config  = app.get('mongo_config')
  seed    = require('./seed')(app)

  app.mongo =
    ObjectID: ObjectID
    seed:     seed.seed
    seed_dir: seed.dir

    stringToID: (id) ->
      return id if id instanceof ObjectID
      try
        new ObjectID.createFromHexString(id)
      catch err
        id

    dateToID: (date) ->
      date = switch true
        when _(date).isDate() then Math.floor(date / 1000)
        else Math.floor(new Date(parseInt(date)) / 1000)
      new ObjectID.createFromTime(date)

    getModel: (source) ->
      source = switch source.constructor.name
        when 'CursorStream' then source._cursor.collection.collectionName
        when 'String' then source
      return global[fleck.inflect(source, 'singularize', 'upperCamelize')]

  MongoClient.connect config.url, config.options, (err, _db) ->
    throw new MongoError(err.message) if err?
    app.mongo.db = _db
    require('./collections')(app)
    require('./lib')(app)
    require('./models')(app)

    if '--seed' in process.argv
      return process.exit(0) unless app.get('env') is 'development'
      console.log '=== Seeding local database ==='
      app.mongo.seed(-> process.exit(0))
