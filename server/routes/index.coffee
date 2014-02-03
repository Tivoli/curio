fs      = require('fs')
params  = require('./params')
mw      = require('./middleware')

# Global handler for populating data to render page chrome
app.get /^((?!png|jpg|js|css|woff|html).)*$/, mw.load_locals, (req, res, next) ->
  res.locals.current_user = req.session?.user
  next()

for file in fs.readdirSync(__dirname)
  path = "#{__dirname}/#{file}"
  continue unless fs.statSync(path)?.isDirectory()
  require(path)(mw)

app.get '/:page_or_post', mw.read

# Bugsnag
unless app.get('env') in ['test', 'development']
  app.use (err, req, res, next) ->
    if not err.statusCode? or /^5\d+/.test(err.statusCode)
      bugsnag.errorHandler(err, req, res, next)
    next(err)

app.use mw.error
