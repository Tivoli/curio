fs            = require('fs')
dust          = require('dustjs-linkedin')
path          = require('path')
template_dir  = path.join app.get('views'), 'templates'
templates     = ''

for file in fs.readdirSync(template_dir) when /dust$/.test(file)
  name      = file.replace '.dust', ''
  data      = fs.readFileSync(path.join(template_dir, file), 'utf8')
  templates += dust.compile(data, name)

exports.index = (req, res) ->
  res.render 'index'

exports.templates = (req, res) ->
  res.set('Content-Type', 'application/javascript')
  res.send templates
