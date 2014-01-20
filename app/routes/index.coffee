params    = require('./params')
mw        = require('./middleware')
site      = require('./site')
configs   = require('./configs')
templates = require('./templates')
sessions  = require('./sessions')
oauth     = require('./oauth')
users     = require('./users')
posts     = require('./posts')
pages     = require('./pages')
cms       = require('./cms')

# Sessionless Routes
app.get '/channel.html', site.channel
app.get '/templates/:templates', templates.read

# Global handler for populating data to render page chrome
app.get /^((?!png|jpg|js|css|woff).)*$/, mw.load_locals, (req, res, next) ->
  res.locals.current_user = req.session?.user
  next()

# Site
app.get '/', site.index

# Configs
app.all '/configs*', mw.restricted
app.get '/configs/:config', mw.read
app.put '/configs/:config', configs.update

# Sessions
app.post '/sessions', sessions.create
app.get '/sessions/token', sessions.token
app.get '/logout', mw.authed, sessions.destroy

# Oauth
app.post '/oauth/:source', oauth.create

# Users
app.get '/users', mw.restricted, users.index
app.post '/users', users.create
app.get '/users/me', mw.authed, users.me
app.post '/users/resetpassword', users.resetpassword
app.get '/users/:user', mw.read
app.put '/users/:user', mw.private, users.update
app.all '/users/:user/roles', mw.restricted, users.update_role

# Posts
app.post '/posts', mw.restricted, posts.create
app.get '/posts/:post', mw.read
app.put '/posts/:post', mw.restricted, utils.save_and_send
app.delete '/posts/:post', mw.restricted, mw.destroy

# Pages
app.post '/pages', mw.restricted, pages.create
app.get '/pages/:page', mw.read
app.put '/pages/:page', mw.restricted, utils.save_and_send
app.delete '/pages/:page', mw.restricted, mw.destroy

# CMS
app.all '/cms*', mw.restricted
app.get '/cms', cms.index

app.get '/:page', mw.read

# Bugsnag
unless /test|development/.test(app.get('env'))
  app.use (err, req, res, next) ->
    if not err.status? or /^5\d+/.test(err.status)
      bugsnag.errorHandler(err, req, res, next)
    next(err)

unless app.get('env') is 'development'
  app.use site.error
