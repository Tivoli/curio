app.locals.env      = app.get('env')
app.locals.app_js   = js('application/bundle')
app.locals.app_css  = css('application/index')
app.locals.fb       = app.get('facebook_config')
app.locals.google   = app.get('google_config')
app.locals.layout   = true
