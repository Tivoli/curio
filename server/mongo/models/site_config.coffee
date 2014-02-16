module.exports = (app) ->
  mongo = app.mongo

  class global.SiteConfig extends Model
    @collection: mongo.configs

    @find: (id, fn) ->
      id = id.toLowerCase()
      @collection.findOne {_id: id}, (err, data) ->
        return fn(err) if err?
        return fn(null, new SiteConfig(data)) if data?
        new SiteConfig(_id: id).save fn

    blacklist: ['id', '_id']

    toJSON: ->
      json        = _(@model).clone()
      json.id     = @_id()
      json.images = @images
      delete json._id
      return json
