exports.index = (req, res, next) ->
  cursor = Post.sorted(req.query.page, req.query.limit)
  utils.cursorJSON cursor, (err, posts) ->
    res.locals.collection = posts
    res.render 'templates/posts/index'
