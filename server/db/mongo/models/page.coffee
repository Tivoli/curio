module.exports = (app) ->
  mongo = app.mongo

  class global.Page extends Model
    @collection: mongo.pages

    allowed: ['path', 'title', 'context']

    title:    -> @model.title
    path:     -> @model.path_original or @model.path
    context:  -> @model.context

    validate: (fn) ->
      return fn(new BadRequest('Missing Path')) unless @path()?.length
      return fn(new BadRequest('Missing Title')) unless @title()?.length
      return fn(new BadRequest('Missing Context')) unless @context()?.length
      fn(null, this)

    whitelist: (values) ->
      updates = _(values).pick(@allowed)
      if updates.path?
        updates.path_original = updates.path
        updates.path          = updates.path.toLowerCase()
      @set(updates)

    toJSON: ->
      id:       @id()
      path:     @path()
      title:    @title()
      context:  @context()
