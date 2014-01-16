fs = require 'fs'

module.exports = require("#{__dirname}/#{file}") for file in fs.readdirSync(__dirname) when "#{__dirname}/#{file}" isnt __filename
