gm = require('gm')

module.exports =
  resize: (width, height, stream, out) ->
    gm(stream)
      .noProfile()
      .resize(width, height, '>')
      .type('TrueColor')
      .stream('jpg').pipe(out)

  crop: (width, height, stream, out) ->
    gm(stream)
      .noProfile()
      .gravity('Center')
      .resize(width, height, '^>')
      .crop(width, height)
      .type('TrueColor')
      .stream('jpg').pipe(out)
