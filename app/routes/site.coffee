fs                = require('fs')
path              = require('path')
template_dir      = path.join app.get('views'), 'templates'
template_reg      = new RegExp("#{template_dir}/(.*).dust$")
templates         = ''

#require('../assets/js/lib/dust_helpers')

for file in utils.walk_dir(template_dir) when /dust$/.test(file)
  data = fs.readFileSync(file, 'utf8')
  name = file.match(template_reg)[1]
  templates += dust.compile(data, "templates/#{name}")

exports.index = (req, res, next) ->
  res.render 'templates/home/index'

exports.error = (err, req, res, next) ->
  res.format
    html: -> res.status(err.status or 500).render("error", {url: req.url, error: err.message})
    json: -> res.json(err.status or 500, {url: req.url, error: err.message})

exports.templates = (req, res) ->
  res.set('Content-Type', 'application/javascript')
  res.send templates

exports.channel = (req, res) ->
  d = new Date()
  d.setFullYear(d.getFullYear()+1)
  res.header 'Cache-Control', 'public,max-age=31536000'
  res.header 'Expires', d.toUTCString()
  res.send '<script src="//connect.facebook.net/en_US/all.js"></script>'
