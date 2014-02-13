fs = require('fs')

module.exports = (app) ->
  module  = {}

  module.randomString = (length=32) ->
    str = ''
    str += Math.random().toString(36).substr(2) while str.length < length
    str.substr(0, length)

  module.shortId = ->
    id = new app.mongo.ObjectID().toHexString()
    return id.substr(0,10)

  module.walk_dir = (dir) ->
    results = []
    for file in fs.readdirSync(dir)
      file = "#{dir}/#{file}"
      stat = fs.statSync(file)
      switch true
        when stat?.isDirectory() then results = results.concat(utils.walk_dir(file))
        else results.push(file)
    return results

  module.is_json_request = (req) ->
    req.is('json') or _(req.accepted).any((a) -> a.subtype is 'json')

  module.save_and_send = (req, res, next) ->
    model = req.resource
    async.waterfall [
      (done) -> done(null, model.whitelist(req.body))
      (model, done) -> model.validate(done)
      (model, done) -> model.save(done)
      (model, done) -> model.populate(done)
    ], (err, model) ->
      return next(err) if err?
      res.json(model.toJSON())

  module.cursorJSON = (cursor, fn) ->
    stream  = cursor.stream()
    model   = app.mongo.getModel(stream)
    data    = []
    stream.on 'data', (item) ->
      stream.pause()
      new model(item).populate (err, item) ->
        return stream.resume() unless item?
        item.set_self?()
        data.push item.toJSON() ; stream.resume()
    stream.on 'close', -> fn(null, data)

  module.streamJSON = (req, res, next, cursor) ->
    utils.cursorJSON cursor, (err, data) ->
      return next(err) if err?
      res.json(data)

  module.load_shared = (dir) ->
    require(file) for file in @walk_dir(dir)

  return module
