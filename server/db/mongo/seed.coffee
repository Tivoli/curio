fs          = require('fs')
path        = require('path')
json2mongo  = require('json2mongo')

module.exports = (app) ->
  module    = {}
  dir_seeds = module.dir = "#{__dirname}/data/seeds"

  module.seed = (done) ->
    mongo = app.mongo
    fs.readdir dir_seeds, (err, files) ->
      return done(err) if err?
      async.each files, (file, fn) ->
        col   = /^(\w+)\./.exec(file)[1]
        docs  = require(path.join(dir_seeds, file))
        docs  = json2mongo(docs)
        console.log('  Seeding %s with %d records', col, docs.length) unless app.get('env') is 'test'
        mongo[col].insert docs, {safe: true, keepGoing: true}, fn
      , done

  return module
