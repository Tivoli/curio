class global.Post extends Model
  @collection: app.mongo.posts

  allowed: ['title', 'context']

  title:    -> @model.title
  context:  -> @model.context

  validate: (fn) ->
    return fn(new Error('Missing Title')) unless @title()?.length
    return fn(new Error('Missing Context')) unless @context()?.length
    User.collection.find({_id: @_user()}).count (err, count) =>
      return fn(err or new Error('Invalid User')) unless count
      fn(null, this)

  whitelist: (values) ->
    updates       = _(values).pick(@allowed)
    updates.slug  = _(updates.title).toSlug() if updates.title?
    @set(updates)

  toJSON: ->
    id:         @id()
    title:      @title()
    slug:       @slug()
    created_at: @created_at()
    context:    @context()
    author:     @author?.toJSON()
