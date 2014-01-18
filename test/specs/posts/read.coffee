describe 'Posts GET read', ->

  before ->
    post = require("#{@seeds}/posts")[0]
    @post = new Post(post).toJSON()

  it 'should not find a post that does not exist', (done) ->
    api.get '/posts/invalid', (e, r, body) ->
      expect(r.statusCode).to.equal 404
      done()

  it 'should get a post by id', (done) ->
    api.get "/posts/#{@post.id}", (e, r, body) =>
      expect(body.id).to.equal @post.id
      expect(body.title).to.equal @post.title
      expect(body.context).to.equal @post.context
      expect(body.created_at).to.equal '2014-01-18T21:21:15.000Z'
      expect(body.author.id).to.equal '52d803b02efbf50f93a8215f'
      expect(body.author.name).to.equal 'Dread Pirate'
      expect(body.author.username).to.equal 'Zombie81'
      done()

  it 'should get a post by slug', (done) ->
    api.get "/posts/#{@post.slug}", (e, r, body) =>
      expect(body.id).to.equal @post.id
      expect(body.title).to.equal @post.title
      expect(body.slug).to.equal @post.slug
      expect(body.context).to.equal @post.context
      expect(body.created_at).to.equal @post.created_at
      expect(body.author.id).to.equal '52d803b02efbf50f93a8215f'
      expect(body.author.name).to.equal 'Dread Pirate'
      expect(body.author.username).to.equal 'Zombie81'
      done()
