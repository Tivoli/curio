express = require('express')
app     = express()
cons    = require('consolidate')
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
global.moment   = require('moment')
global.request  = require('request').defaults(_json: true)
global.dust     = require('dustjs-linkedin') ; require('dustjs-helpers')
global.utils    = require('./utilities')(app)
utils.load_shared("#{__dirname}/shared")

require('./errors')
require('./configs')(app)
require('./db/redis')(app)
require('./db/mongo')(app)

RedisStore  = require('connect-redis')(express)
app.sessionStore  = new RedisStore(app.get('redis_config'))

app.engine('dust', cons.dust)
app.set 'port', process.env.PORT or 3000
app.set 'version', require('../package').version
app.set 'description', require('../package').description
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'dust'
app.set 'apps', "#{__dirname}/apps"
app.set 'assets', assets
app.set 'middleware', require('./middleware')(app)
app.use express.favicon("#{__dirname}/public/favicon.png", maxAge: 2592000000)
app.use express.urlencoded()
app.use express.json()
app.use express.cookieParser('curio cookie')
app.use express.session(cookie: {maxAge: 604800000}, store: app.sessionStore)
app.use express.methodOverride()
app.use '/templates', require('./apps/templates')(app)
app.use '/uploads', require('./apps/uploads')(app)
app.use '/cms', require('./apps/cms')(app)
app.use '/', require('./apps/website')(app)
app.use app.get('middleware').error

if app.get('env') is 'development'
  app.use express.logger('dev')
  app.use express.static("#{__dirname}/public")
  app.use express.compress()
else
  app.use express.static("#{__dirname}/public", maxAge: 86400000)
  app.use express.compress()

unless  '--seed' in process.argv
  server = require('http').createServer(app)
  server.listen app.get("port"), ->
    unless process.env.NODE_COV
      timestamp = moment().format('D MMM H:mm:ss')
      console.log("%s - %s v%s (#{blue}%s#{reset}) port #{red}%d#{reset}", timestamp, app.get('description'), app.get('version'), app.get('env'), app.get('port'))

process.on 'SIGINT', ->
  async.series
    redis: (done) -> app.redis.quit(done)
    mongo: (done) -> app.mongo.db.close(done)
    server: (done) -> server.close(done)
  , (err, results) -> process.exit(0)
  setTimeout ->
    console.error "Forcefully shutting down"
    process.exit(1)
  , 30*1000

module.exports = app
