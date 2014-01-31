class global.BadRequest extends Error
  constructor: (@message) ->
    @status = 400
    super()

class global.Unauthorized extends Error
  constructor: ->
    @status = 401
    @message = 'Unauthorized'

class global.NotFound extends Error
  constructor: (@message) ->
    @status = 404
    super()

class global.MongoError extends Error
  constructor: (@message) ->
    @status = 500
    super()

class global.RedisError extends Error
  constructor: (@message) ->
    @status = 500
    super()
