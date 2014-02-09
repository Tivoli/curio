crypto  = require('crypto')
aws     = null

exports.randomString = (length=32) ->
  str = ''
  str += Math.random().toString(36).substr(2) while str.length < length
  str.substr(0, length)

exports.shortId = ->
  id = new app.mongo.ObjectID().toHexString()
  return id.substr(0,10)

exports.walk_dir = (dir) ->
  results = []
  for file in fs.readdirSync(dir)
    file = "#{dir}/#{file}"
    stat = fs.statSync(file)
    switch true
      when stat?.isDirectory() then results = results.concat(utils.walk_dir(file))
      else results.push(file)
  return results

exports.is_json_request = (req) ->
  req.is('json') or _(req.accepted).any((a) -> a.subtype is 'json')

exports.save_and_send = (req, res, next) ->
  model = req.resource
  async.waterfall [
    (done) -> done(null, model.whitelist(req.body))
    (model, done) -> model.validate(done)
    (model, done) -> model.save(done)
    (model, done) -> model.populate(done)
  ], (err, model) ->
    return next(err) if err?
    res.json(model.toJSON())

exports.cursorJSON = (cursor, fn) ->
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

exports.streamJSON = (req, res, next, cursor) ->
  utils.cursorJSON cursor, (err, data) ->
    return next(err) if err?
    res.json(data)

exports.load_shared = (dir) ->
  require(file) for file in @walk_dir(dir)

exports.cors_policy = ->
  aws ?= app.get('aws_config')
  s3_policy =
    expiration: new Date(Date.now() + (60*30*1000)).toISOString()
    conditions: [
      { bucket: aws.s3.bucket }
      { acl: "public-read" }
      { success_action_status: '201' }
      ["starts-with", "$key", ""]
      ["starts-with", "$Content-Type", ""]
    ]
  new Buffer(JSON.stringify(s3_policy)).toString('base64')

exports.cors_signature = (policy) ->
  crypto.createHmac('sha1', aws.secret).update(policy).digest('base64')
