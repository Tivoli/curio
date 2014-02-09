module.exports = (app, mw) ->
  app.get '*', mw.restricted

  for file in fs.readdirSync(__dirname)
    path = "#{__dirname}/#{file}"
    continue unless fs.statSync(path)?.isDirectory()
    require(path)(app, mw)
