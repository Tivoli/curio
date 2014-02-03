app.param ':config', (req, res, next, id) ->
  SiteConfig.find id, (err, config) ->
    return next(err) if err?
    req.resource = config
    next()

app.param ':source', (req, res, next, source) ->
  model = global[fleck.capitalize(source)]
  new model(req.body).validate (err, source) ->
    return next(err) if err?
    req.source = source
    next()

app.param ':user', (req, res, next, id) ->
  User.find id, (err, user) ->
    return next(err) if err?
    req.resource = user
    req.resource.set_self() if req.resource.id() is req.session?.user?.id
    next()

app.param ':post', (req, res, next, id) ->
  Post.find id, (err, post) ->
    return next(err) if err?
    req.resource = post
    next()

app.param ':page', (req, res, next, id) ->
  Page.find id, (err, page) ->
    return next(err) if err?
    req.resource = page
    next()

app.param ':page_or_post', (req, res, next, id) ->
  async.parallel
    post: (done) -> Post.find(id, (err, post) -> done(null, post))
    page: (done) -> Page.find(id, (err, page) -> done(null, page))
  , (err, results) ->
    unless results.post? or results.page?
      return next(new NotFound('Page not found'))
    req.resource = results.page or results.post
    next()
