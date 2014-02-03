app.param ':page_or_post', (req, res, next, id) ->
  async.parallel
    post: (done) -> Post.find(id, (err, post) -> done(null, post))
    page: (done) -> Page.find(id, (err, page) -> done(null, page))
  , (err, results) ->
    unless results.post? or results.page?
      return next(new NotFound('Page not found'))
    req.resource = results.page or results.post
    next()
