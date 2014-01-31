exports.create = (req, res, next) ->
  req.source.find_or_create_user (err, source) ->
    return next(err) if err?
    source.update_user (err, source) ->
      return next(err) if err?
      json = source.user.set_self().toJSON()
      req.session.user = json
      res.json json
