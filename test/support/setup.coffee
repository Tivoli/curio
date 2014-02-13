require('./browser')
require('./fakeweb')

global.curio = app = require('../../server')
global.db       = require('./database')(app)
global.api      = require('./api')
global.factory  = require('./factory')
global.expect   = require('chai').expect
