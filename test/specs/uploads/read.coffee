gm = require('gm')

describe 'Uploads GET show', ->

  it 'should get the default image with no params', (done) ->
    stream  = request.get('http://localhost:3001/uploads/images/image')
    gm(stream).size (err, size) ->
      expect(size.width).to.equal 1024
      expect(size.height).to.equal 768
      done()

  it 'should get a resized image by width', (done) ->
    stream  = request.get('http://localhost:3001/uploads/images/image?w=100')
    gm(stream).size (err, size) ->
      expect(size.width).to.equal 100
      expect(size.height).to.equal 75
      done()

  it 'should get a resized image by height', (done) ->
    stream  = request.get('http://localhost:3001/uploads/images/image?h=100')
    gm(stream).size (err, size) ->
      expect(size.width).to.equal 133
      expect(size.height).to.equal 100
      done()

  it 'should get a cropped and resized image', (done) ->
    stream  = request.get('http://localhost:3001/uploads/images/image?w=50&h=50&m=crop')
    gm(stream).size (err, size) ->
      expect(size.width).to.equal 50
      expect(size.height).to.equal 50
      done()
