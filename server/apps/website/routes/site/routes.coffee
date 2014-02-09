exports.index = (req, res, next) ->
  res.render 'templates/home/index'

exports.channel = (req, res) ->
  d = new Date()
  d.setFullYear(d.getFullYear()+1)
  res.header 'Cache-Control', 'public,max-age=31536000'
  res.header 'Expires', d.toUTCString()
  res.send '<script src="//connect.facebook.net/en_US/all.js"></script>'
