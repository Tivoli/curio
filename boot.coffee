cluster     = require('cluster')
cpus        = require('os').cpus().length
description = require('./package').description
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

return require('./app/server') if process.env.NODE_ENV in ['test', 'development']

if cluster.isMaster
  cluster.on 'exit', (worker) ->
    console.log "#{description} #{worker.id} died.  restart..."
    cluster.fork()

  cluster.fork() while cpus--
else
  require('./app')
