module.exports = (app) ->

  routes =
    update: (req, res, next) ->
      delete app.locals.website if req.param('config') is 'website'
      utils.save_and_send(req, res, next)

  return routes
