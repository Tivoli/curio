describe 'Search GET index', ->

  it 'should not search without a query', (done) ->
    api.get '/search', {core: 'users'}, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Query'
      done()

  it 'should not search without a core', (done) ->
    api.get '/search', {q: 'users'}, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Core'
      done()

  describe 'users', ->

    it 'should not find any users', (done) ->
      api.get '/search', {q: 'nouser', core: 'users'}, (e, r, body) ->
        expect(body.length).to.equal 0
        done()

    it 'should find users by username', (done) ->
      api.get '/search', {q: 'zombie', core: 'users'}, (e, r, body) ->
        expect(body.length).to.equal 20
        expect(_(body).every((user) -> /zombie/i.test(user.username))).to.be.true
        done()

  describe 'posts', ->

    it 'should not find any posts', (done) ->
      api.get '/search', {q: 'nopost', core: 'posts'}, (e, r, body) ->
        expect(body.length).to.equal 0
        done()

    it 'should find posts by slug', (done) ->
      api.get '/search', {q: 'blog-entry', core: 'posts'}, (e, r, body) ->
        expect(body.length).to.equal 20
        expect(_(body).every((post) -> /^blog-entry/.test(post.slug))).to.be.true
        done()

    it 'should find posts by title', (done) ->
      api.get '/search', {q: 'Blog', core: 'posts'}, (e, r, body) ->
        expect(body.length).to.equal 20
        expect(_(body).every((post) -> /^blog-entry/.test(post.slug))).to.be.true
        done()
