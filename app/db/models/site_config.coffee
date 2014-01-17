class global.SiteConfig extends Model
  @collection: app.mongo.configs

  @find: (id, fn) ->
    id = id.toLowerCase()
    @collection.findOne {_id: id}, (err, data) ->
      return fn(err) if err?
      return new SiteConfig(data).populate(fn) if data?
      new SiteConfig(_id: id).save fn

  blacklist: ['id', '_id', 'images']

  whitelist: (values) ->
    updates = _(values).omit(@blacklist)
    @set(updates)

  toJSON: ->
    json        = _(@model).clone()
    json.id     = @_id()
    json.images = @images
    delete json._id
    return json
