describe 'Sessions POST create', ->
  beforeEach ->
    @user =
      email:    'zombie1@example.com'
      password: 'wantsbrains'

  it 'should not sign in with missing information', (done) ->
    api.post '/sessions', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not login with a missing email', (done) ->
    delete @user.email
    api.post '/sessions', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not login with a missing password', (done) ->
    delete @user.password
    api.post '/sessions', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not login with an invalid email', (done) ->
    @user.email = 'invalid'
    api.post '/sessions', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not login with a bad password', (done) ->
    @user.password = 'invalid'
    api.post '/sessions', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should login with credentials', (done) ->
    api.post '/sessions', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.username).to.equal 'Zombie1'
      expect(body.name).to.equal 'Dread Pirate'
      expect(body.email).to.equal 'zombie1@example.com'
      expect(body).to.not.have.property('password')
      done()
