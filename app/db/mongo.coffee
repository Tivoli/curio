fs          = require('fs')
mongodb     = require('mongodb')
json2mongo  = require('json2mongo')
config      = app.get('mongo_config')
MongoClient = mongodb.MongoClient
ObjectID    = mongodb.ObjectID
GridStore   = mongodb.GridStore

seed = (done) ->
  files = fs.readdirSync("#{__dirname}/data/seeds")
  do run = ->
    return done() unless files.length
    file  = files.shift()
    col   = /^(\w+)\./.exec(file)[1]
    docs  = require("#{__dirname}/data/seeds/#{file}")
    docs  = json2mongo(docs)
    console.log('  Seeding %s with %d records', col, docs.length) unless app.get('env') is 'test'
    app.mongo[col].insert docs, {safe: true, keepGoing: true}, run

app.mongo =
  ObjectID:   ObjectID
  GridStore:  GridStore
  seed:       seed

  stringToID: (id) ->
    return id if id instanceof ObjectID
    try
      new ObjectID.createFromHexString(id)
    catch err
      id

  dateToID: (date) ->
    date = switch true
      when date instanceof Date then Math.floor(date / 1000)
      else Math.floor(new Date(parseInt(date)) / 1000)
    new ObjectID.createFromTime(date)

require('./social_model')

MongoClient.connect config.url, config.options, (err, client) ->
  return console.log(err) if err?
  app.mongo.client  = client
  db = app.mongo.db = client.db(config.db)

  app.mongo.users         = db.collection('users')
  app.mongo.configs       = db.collection('configs')
  app.mongo.fs_files      = db.collection('fs.files')
  app.mongo.fs_chunks     = db.collection('fs.chunks')

  require('./mongo_indexes')
  require('./models')

  for file in fs.readdirSync("#{__dirname}/models")
    require("./models/#{file}")

  if '--seed' in process.argv
    return process.exit(0) unless app.get('env') is 'development'
    console.log '=== Seeding local database ==='
    app.mongo.seed(-> process.exit(0))
