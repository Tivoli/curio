exports.index = (req, res, next) ->
  cursor = User.sorted(req.query.page, req.query.limit)
  utils.cursorJSON cursor, (err, users) ->
    res.locals.collection = users
    res.render 'templates/users/index'
