module.exports = (app, mw) ->
  load_locals = (req, res, next) ->
    return next() if app.locals.website?
    SiteConfig.find 'website', (err, config) ->
      return next() if err?
      app.locals.website = config.toJSON()
      next()

  # Global handler for populating data to render page chrome
  app.get /^((?!png|jpg|js|css|woff|html).)*$/, load_locals, (req, res, next) ->
    res.locals.current_user = req.session?.user
    next()

  for file in fs.readdirSync(__dirname)
    path = "#{__dirname}/#{file}"
    continue unless fs.statSync(path)?.isDirectory()
    require(path)(app, mw)

  app.param ':page_or_post', (req, res, next, id) ->
    async.parallel
      post: (done) -> Post.find(id, (err, post) -> done(null, post))
      page: (done) -> Page.find(id, (err, page) -> done(null, page))
    , (err, results) ->
      unless results.post? or results.page?
        return next(new NotFound('Page not found'))
      req.resource = results.page or results.post
      next()

  app.get '/:page_or_post', mw.read
