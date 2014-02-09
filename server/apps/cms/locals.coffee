module.exports = (app, core) ->
  app.locals.layout   = true
  app.locals.env      = app.get('env')
  app.locals.js       = js('cms/bundle')
  app.locals.css      = css('cms/index')
  app.locals.fb       = core.get('facebook_config')
  app.locals.google   = core.get('google_config')
