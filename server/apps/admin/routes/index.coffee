fs = require('fs')

module.exports = (app, mw) ->
  mw  = app.get('middleware')
  app.get '*', mw.restricted

  for file in fs.readdirSync(__dirname)
    path = "#{__dirname}/#{file}"
    continue unless fs.statSync(path)?.isDirectory()
    require(path)(app, mw)
