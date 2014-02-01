express = require('express')
cons    = require('consolidate')
busboy  = require('connect-busboy')
blue    = '\u001b[34m'
red     = '\u001b[31m'
reset   = '\u001b[0m'

assets  = [
  "#{__dirname}/assets/js"
  "#{__dirname}/shared"
  "#{__dirname}/assets/css"
]

global._        = require('underscore')
global.async    = require('async')
global.fleck    = require('fleck')
global.request  = require('request').defaults(_json: true)
global.app      = express()
global.bugsnag  = require('bugsnag')
global.dust     = require('dustjs-linkedin') ; require('dustjs-helpers')
global.utils    = require('./utilities')

require('./errors')
require('./configs')

RedisStore  = require('connect-redis')(express)
app.sessionStore  = new RedisStore(app.get('redis_config'))

app.configure ->
  app.engine('dust', cons.dust)
  app.set 'port', process.env.PORT or 3000
  app.set 'version', require('../package').version
  app.set 'description', require('../package').description
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'dust'
  app.use express.favicon("#{__dirname}/public/favicon.png", maxAge: 2592000000)
  app.use express.urlencoded()
  app.use express.json()
  app.use busboy()
  app.use express.cookieParser('boilerplate cookie')
  app.use express.session(cookie: {maxAge: 604800000}, store: app.sessionStore)
  app.use express.methodOverride()
  app.use app.router

app.configure 'development', ->
  app.use express.logger('dev')
  app.use express.static("#{__dirname}/public")
  app.use require('connect-assets')(paths: assets)
  app.use express.compress()

app.configure 'test', 'staging', 'production', ->
  bugsnag.register(app.get('bugsnag_config').key) unless app.get('env') is 'test'
  app.use express.static("#{__dirname}/public", maxAge: 86400000)
  app.use bugsnag.requestHandler
  app.use require('connect-assets')(paths: assets, build: true)
  app.use express.compress()

require('./db/mongo')
require('./db/redis')
require('./locals')
require('./routes')

unless  '--seed' in process.argv
  server = require('http').createServer(app)
  server.listen app.get("port"), ->
    unless process.env.NODE_COV
      months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      now = new Date()
      console.log("%d %s %s - %s v%s (#{blue}%s#{reset}) port #{red}%d#{reset}", now.getDate(), months[now.getMonth()], now.toLocaleTimeString(), app.get('description'), app.get('version'), app.get('env'), app.get('port'))

process.on 'SIGINT', ->
  async.series
    redis: (done) -> app.redis.quit(done)
    mongo: (done) -> app.mongo.client.close(done)
    server: (done) -> server.close(done)
  , (err, results) -> process.exit(0)
  setTimeout ->
    console.error "Forcefully shutting down"
    process.exit(1)
  , 30*1000
