describe 'Posts DELETE destroy', ->

  before ->
    post  = require("#{@seeds}/posts")[30]
    @post = new Post(post).toJSON()

  it 'should not destroy a post without a user', (done) ->
    api.delete "/posts/#{@post.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not destroy a post without an admin user', (done) ->
    api.delete "/posts/#{@post.id}", @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should destroy a post with an admin user', (done) ->
    api.delete "/posts/#{@post.id}", @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      done()

  it 'should no longer exist', (done) ->
    api.get "/posts/#{@post.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 404
      done()
