describe 'Posts PUT update', ->

  before ->
    post        = require("#{@seeds}/posts")[50]
    @base_post  = new Post(post).toJSON()

  beforeEach ->
    @post = _(@base_post).clone()

  it 'should not update a post without a user', (done) ->
    api.put "/posts/#{@post.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not update a post without an admin user', (done) ->
    api.put "/posts/#{@post.id}", @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should update a post title', (done) ->
    @post.title = 'New Post Title'
    api.put "/posts/#{@post.id}", @post, @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.title).to.equal 'New Post Title'
      expect(body.slug).to.equal 'new-post-title'
      @base_post = body
      done()

  it 'should update a post context', (done) ->
    @post.context = 'Updated blog post context'
    api.put "/posts/#{@post.id}", @post, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.title).to.equal 'New Post Title'
      expect(body.slug).to.equal 'new-post-title'
      expect(body.context).to.equal 'Updated blog post context'
      done()
