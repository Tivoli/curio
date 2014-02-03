exports.index = (req, res, next) ->
  return next(new BadRequest('Missing Query')) unless req.query.q?
  return next(new BadRequest('Missing Core')) unless req.query.core?
  model   = global[fleck.inflect(req.query.core, 'singularize', 'capitalize')]
  query = switch req.query.core
    when 'users' then {username: new RegExp("#{req.query.q}", 'i')}
    when 'posts' then {slug: new RegExp(_(req.query.q).toSlug())}
  cursor  = model.search(query, req.query.page, req.query.limit)
  utils.streamJSON(req, res, next, cursor)
