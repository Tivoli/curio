# Everything we need to start the app
express     = require('express')
dust        = require('dustjs-linkedin')
cons        = require('consolidate')
bugsnag     = require('bugsnag')
RedisStore  = require('connect-redis')(express)

# Any modules that are used heavily around the app
global._        = require('underscore')
global.async    = require('async')
global.fleck    = require('fleck')
global.request  = require('request').defaults(_json: true)
global.app      = express()

require('./configs')
app.sessionStore  = new RedisStore(app.get('redis_config'))

# Configure the app defaults
app.configure ->
  app.engine('dust', cons.dust)
  app.set 'port', process.env.PORT or 3000
  app.set 'version', require('./package').version
  app.set 'description', require('./package').description
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'dust'
  app.use express.favicon("#{__dirname}/public/favicon.ico", maxAge: 2592000000)
  app.use express.bodyParser(uploadDir: '/tmp', keepExtensions: true)
  app.use express.cookieParser('cat haz cookie')
  app.use express.session(cookie: { maxAge: 604800000 }, store: app.sessionStore)
  app.use express.methodOverride()
  app.use app.router

# Specific environment configurations
app.configure 'development', ->
  app.use express.logger('dev')
  app.use express.static("#{__dirname}/public")
  app.use express.errorHandler(dumpExceptions: true, showStack: true)
  app.use require('connect-assets')()
  app.use express.compress()

app.configure 'test', 'staging', 'production', ->
  app.use express.static("#{__dirname}/public", maxAge: 86400000)
  app.use express.errorHandler()
  app.use require('connect-assets')(build: true)
  app.use express.compress()
  app.use bugsnag.register("bugsnag key")

require('./locals')
require('./routes')

# Start up the server and socket.io
server = require('http').createServer(app)
server.listen app.get("port"), ->
  months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  now = new Date()
  console.log("%d %s %s - %s v%s (%s) port %d", now.getDate(), months[now.getMonth()], now.toLocaleTimeString(), app.get('description'), app.get('version'), app.get('env'), app.get('port'))
  require('./socket')(server)

