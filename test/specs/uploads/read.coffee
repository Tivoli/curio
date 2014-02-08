describe 'Uploads GET show', ->

  it 'should get a resized image by width', (done) ->
    resized = fs.readFileSync("#{@test_dir}/support/images/image_w_100.jpg").toString('base64')
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?w=100')
    stream.on 'data', (data) -> buffers.push(data)
    stream.on 'end', ->
      expect(resized).to.equal Buffer.concat(buffers).toString('base64')
      done()

  it 'should get a resized image by height', (done) ->
    resized = fs.readFileSync("#{@test_dir}/support/images/image_h_100.jpg").toString('base64')
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?h=100')
    stream.on 'data', (data) -> buffers.push(data)
    stream.on 'end', ->
      expect(resized).to.equal Buffer.concat(buffers).toString('base64')
      done()

  it 'should get a cropped and resized image', (done) ->
    resized = fs.readFileSync("#{@test_dir}/support/images/image_crop_50.jpg").toString('base64')
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?w=50&h=50&m=crop')
    stream.on 'data', (data) -> buffers.push(data)
    stream.on 'end', ->
      expect(resized).to.equal Buffer.concat(buffers).toString('base64')
      done()
