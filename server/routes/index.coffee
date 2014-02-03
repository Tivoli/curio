params    = require('./params')
mw        = require('./middleware')
site      = require('./site')

# Sessionless Routes
app.get '/channel.html', site.channel
require('./templates')(mw)

# Global handler for populating data to render page chrome
app.get /^((?!png|jpg|js|css|woff).)*$/, mw.load_locals, (req, res, next) ->
  res.locals.current_user = req.session?.user
  next()

# Site
app.get '/', site.index

require('./configs')(mw)
require('./sessions')(mw)
require('./oauth')(mw)
require('./users')(mw)
require('./posts')(mw)
require('./pages')(mw)
require('./cms')(mw)

app.get '/:page_or_post', mw.read

# Bugsnag
unless app.get('env') in ['test', 'development']
  app.use (err, req, res, next) ->
    if not err.statusCode? or /^5\d+/.test(err.statusCode)
      bugsnag.errorHandler(err, req, res, next)
    next(err)

app.use site.error
