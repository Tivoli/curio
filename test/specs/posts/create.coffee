describe 'Posts POST create', ->

  before ->
    @base_post = factory.post()

  beforeEach ->
    @post = _(@base_post).clone()

  it 'should require a user to create a post', (done) ->
    api.post '/posts', @post, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require an admin user to create a post', (done) ->
    api.post '/posts', @post, @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require a title to create a post', (done) ->
    delete @post.title
    api.post '/posts', @post, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Title'
      done()

  it 'should require a body to create a post', (done) ->
    delete @post.context
    api.post '/posts', @post, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Context'
      done()

  it 'should create a post', (done) ->
    api.post '/posts', @post, @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.title).to.equal @post.title
      expect(body.context).to.equal @post.context
      expect(body).to.have.property 'created_at'
      expect(body.author).to.have.property 'name'
      expect(body.author).to.have.property 'username'
      done()
