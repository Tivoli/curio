gm = require('gm')

exports.resize = (width, height, stream, out) ->
  gm(stream)
    .noProfile()
    .resize(width, height, '>')
    .type('TrueColor')
    .stream('jpg').pipe(out)

exports.crop = (width, height, stream, out) ->
  gm(stream)
    .noProfile()
    .gravity('Center')
    .resize(width, height, '^>')
    .crop(width, height)
    .type('TrueColor')
    .stream('jpg').pipe(out)
