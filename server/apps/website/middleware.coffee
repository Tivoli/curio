module.exports = (app) ->
  module = {}

  module.load_locals = (req, res, next) ->
    return next() if app.locals.website?
    SiteConfig.find 'website', (err, config) ->
      return next() if err?
      app.locals.website = config.toJSON()
      next()

  return module
