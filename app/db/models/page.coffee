class global.Page extends Model
  @collection: app.mongo.pages

  allowed: ['path', 'context']

  path:     -> @model.path_original or @model.path
  context:  -> @model.context

  validate: (fn) ->
    return fn(new Error('Missing Path')) unless @path()?.length
    return fn(new Error('Missing Context')) unless @context()?.length
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
    context:  @context()
