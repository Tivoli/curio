class global.BadRequest extends Error
  constructor: (@message) ->
    @statusCode = 400
    super()

class global.Unauthorized extends Error
  constructor: ->
    @statusCode = 401
    @message = 'Unauthorized'
    super()

class global.NotFound extends Error
  constructor: (@message) ->
    @statusCode = 404
    super()

class global.MongoError extends Error
  constructor: (@message) ->
    @statusCode = 500
    super()
