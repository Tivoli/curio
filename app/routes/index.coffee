params    = require('./params')
mw        = require('./middleware')
site      = require('./site')
users     = require('./users')
sessions  = require('./sessions')
oauth     = require('./oauth')

# Sessionless Routes
app.get '/js/templates.js', site.templates
app.get '/channel.html', site.channel

# Global handler for populating data to render page chrome
app.get /^((?!png|jpg|js|css|woff).)*$/, mw.load_locals, (req, res, next) ->
  res.locals.current_user = req.session?.user
  next()

# Site
app.get '/', site.index

# Users
app.get '/users', mw.restricted, users.index
app.post '/users', users.create
app.get '/users/me', mw.authed, users.me
app.post '/users/resetpassword', users.resetpassword
app.get '/users/:user', users.read
app.put '/users/:user', mw.private, users.update

# Sessions
app.post '/sessions', sessions.create
app.get '/sessions/token', sessions.token
app.get '/logout', mw.authed, sessions.destroy

# Oauth
app.post '/oauth/:source', oauth.create

# Bugsnag
unless /test|development/.test(app.get('env'))
  app.use (err, req, res, next) ->
    if not err.status? or /^5\d+/.test(err.status)
      bugsnag.errorHandler(err, req, res, next)
    next(err)

unless app.get('env') is 'development'
  app.use site.error
