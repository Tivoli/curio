fs    = require('fs')

module.exports = for file in fs.readdirSync(__dirname) when "#{__dirname}/#{file}" isnt __filename
  require("#{__dirname}/#{file}")
