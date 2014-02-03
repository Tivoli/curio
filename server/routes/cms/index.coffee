mw      = require('../middleware')
routes  = require('./routes')

_(app.locals).extend
  cms_js:   js('cms/bundle')
  cms_css:  css('cms/index')

app.get '/cms*', mw.restricted, routes.index
