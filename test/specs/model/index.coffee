describe 'Model', ->

  it 'should not find a model with a null id', (done) ->
    User.find null, (err, user) ->
      expect(err.message).to.equal 'Missing query param for User'
      done()

  it 'should not find a model with an invalid id', (done) ->
    User.find 'inval!d', (err, user) ->
      expect(err.message).to.equal 'Missing query param for User'
      done()
