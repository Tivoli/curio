fs        = require('fs')
path      = require('path')
compiled  = {}

#require('../assets/js/lib/dust_helpers')
compile = (type) ->
  directory = path.join(app.get('views'), type)
  regex     = new RegExp("#{directory}/(.*).dust$")
  templates = []
  for file in utils.walk_dir(directory) when /dust$/.test(file)
    data = fs.readFileSync(file, 'utf8')
    name = file.match(regex)[1]
    templates.push dust.compile(data, "#{type}/#{name}")
  return templates.join('')

exports.read = (req, res, next) ->
  type = req.params.templates
  type = path.basename(type, '.js')
  res.set('Content-Type', 'application/javascript')
  compiled[type] ?= compile(type)
  res.send(compiled[type])
