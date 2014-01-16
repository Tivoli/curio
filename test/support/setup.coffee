require('../../app/server')
require('./browser')
require('./fakeweb')
global.db       = require('./database')
global.api      = require('./api')
global.factory  = require('./factory')
global.expect   = require('chai').expect
