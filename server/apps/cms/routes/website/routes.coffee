exports.index = (req, res, next) ->
  async.parallel
    website: (done) -> SiteConfig.find('website', done)
  , (err, results) ->
    res.locals[k] = v.toJSON() for k, v of results
    res.render 'templates/website/index'
