fs = require 'fs'
module.exports = {}

for file in fs.readdirSync(__dirname) when "#{__dirname}/#{file}" isnt __filename
  name = file.replace '.coffee', ''
  module.exports[name] = require("./#{name}")
