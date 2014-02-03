describe 'Posts GET index', ->
  posts = null

  it 'should get a set of posts', (done) ->
    api.get '/posts', (e, r, body) ->
      expect(body.length).to.equal 20
      posts = body
      done()

  it 'should get page 2 of posts', (done) ->
    api.get '/posts', {page: 2}, (e, r, body) ->
      expect(body.length).to.equal 20
      ids = (post.id for post in posts)
      expect(_(body).every((post) -> not (post.id in ids))).to.be.true
      done()

  it 'should get a limited set of posts', (done) ->
    api.get '/posts', {limit: 5}, (e, r, body) ->
      expect(body.length).to.equal 5
      ids = (post.id for post in posts.slice(0,5))
      expect(_(body).every((post) -> post.id in ids)).to.be.true
      done()

  it 'should get a limited set of posts with pagination', (done) ->
    api.get '/posts', {page: 2, limit: 5}, (e, r, body) ->
      expect(body.length).to.equal 5
      ids = (post.id for post in posts.slice(4,10))
      expect(_(body).every((post) -> post.id in ids)).to.be.true
      done()
