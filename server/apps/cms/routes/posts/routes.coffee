exports.index = (req, res, next) ->
  cursor = Post.sorted(req.param('page'), req.param('limit'))
  utils.cursorJSON cursor, (err, posts) ->
    res.locals.collection = posts
    res.render 'templates/posts/index'
