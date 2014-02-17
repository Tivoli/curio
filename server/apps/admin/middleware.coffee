module.exports = (app) ->
  module = {}

  module.render_index = (req, res, next) ->
    root    = req.route.path.slice(1)
    model   = utils.to_model(root)
    cursor  = model.sorted(req.param('page'), req.param('limit'))
    utils.cursorJSON cursor, (err, json) ->
      res.locals.collection = json
      res.render "templates/#{root}/index"

  return module
