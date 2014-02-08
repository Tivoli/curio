describe 'Uploads GET show', ->

  it 'should get a resized image by width', (done) ->
    console.log @test_dir
    resized = fs.readFileSync("#{@test_dir}/support/images/image_w_100.jpg")
    console.log resized
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?w=100')
    stream.on 'data', (data) ->
      console.log 'buffers'
      buffers.push(data)
    stream.on 'end', ->
      buffer = Buffer.concat(buffers)
      expect(buffer).to.deep.equal resized
      done()

  it 'should get a resized image by height', (done) ->
    resized = fs.readFileSync("#{@test_dir}/support/images/image_h_100.jpg")
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?h=100')
    stream.on 'data', (data) -> buffers.push(data)
    stream.on 'end', ->
      buffer = Buffer.concat(buffers)
      expect(buffer).to.deep.equal resized
      done()

  it 'should get a cropped and resized image', (done) ->
    resized = fs.readFileSync("#{@test_dir}/support/images/image_crop_50.jpg")
    buffers = []
    stream  = request.get('http://localhost:3001/uploads/images/image?w=50&h=50&m=crop')
    stream.on 'data', (data) -> buffers.push(data)
    stream.on 'end', ->
      buffer = Buffer.concat(buffers)
      expect(buffer).to.deep.equal resized
      done()
