fs = require 'fs'

for file in fs.readdirSync(__dirname) when /\.json$/.test(file)
  name    = file.replace '.json', ''
  json    = require "./#{name}"
  config  = _.extend {}, json.defaults, json[app.get('env')]
  app.set "#{name}_config", config
