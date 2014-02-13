fs = require('fs')

module.exports = (app) ->
  for file in fs.readdirSync(__dirname) when /^((?!index).)*$/.test(file)
    require("./#{file}")(app)
