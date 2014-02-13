fs        = require('fs')
express   = require('express')
app       = express()
path      = require('path')
compiled  = {}

module.exports = (core) ->

  compile = (type) ->
    directory = path.join(core.get('apps'), type, 'views', 'templates')
    regex     = new RegExp("#{directory}/(.*).dust$")
    templates = []
    for file in utils.walk_dir(directory) when /dust$/.test(file)
      data = fs.readFileSync(file, 'utf8')
      name = file.match(regex)[1]
      templates.push dust.compile(data, "templates/#{name}")
    return templates.join('')

  app.get '/:templates', (req, res, next) ->
    type = path.basename(req.params.templates, '.js')
    res.set('Content-Type', 'application/javascript')
    compiled[type] ?= compile(type)
    res.send(compiled[type])

  return app
