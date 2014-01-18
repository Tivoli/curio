exports.index = (req, res, next) ->
  res.render 'templates/home/index'

exports.error = (err, req, res, next) ->
  res.format
    html: ->
      return res.redirect('/') if err.status is 401
      res.status(err.status or 500).render("error", {url: req.url, error: err.message})
    json: -> res.json(err.status or 500, {url: req.url, error: err.message})

exports.channel = (req, res) ->
  d = new Date()
  d.setFullYear(d.getFullYear()+1)
  res.header 'Cache-Control', 'public,max-age=31536000'
  res.header 'Expires', d.toUTCString()
  res.send '<script src="//connect.facebook.net/en_US/all.js"></script>'
