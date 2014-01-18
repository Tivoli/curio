describe 'Users POST create', ->

  before ->
    @base_user = factory.user()

  beforeEach ->
    @user = _(@base_user).clone()

  it 'should not create a user without an email', (done) ->
    delete @user.email
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Email'
      done()

  it 'should not create a user with an invalid email', (done) ->
    @user.email = 'invalid'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Email'
      done()

  it 'should not create a user with an invalid username', (done) ->
    @user.username = 'inval!d'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Username'
      done()

  it 'should not create a user with a blocked username', (done) ->
    @user.username = 'admin'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Username'
      done()

  it 'should not create a user without a password', (done) ->
    delete @user.password
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Password'
      done()

  it 'should not create a user with an invalid password', (done) ->
    @user.password = '12345'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Password too short'
      done()

  it 'should not create a user without a name', (done) ->
    delete @user.name
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Name'
      done()

  it 'should not create a user with an invalid name', (done) ->
    @user.name = 'invalid!'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Name'
      done()

  it 'should create a user', (done) ->
    api.post '/users', @user, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.have.property('id')
      expect(body.email).to.equal @user.email.toLowerCase()
      expect(body.name).to.equal @user.name
      expect(body.username).to.equal @user.username
      expect(body).to.not.have.property('password')
      _(@base_user).extend(body)
      @cookie = r.headers['set-cookie'].pop().split(';')[0]
      done()

  it 'should update cached user session', (done) ->
    delete @user.password
    api.get '/users/me', @cookie, (e, r, body) =>
      expect(body).to.deep.equal @user
      done()

  it 'should not store a users plain text password', (done) ->
    app.mongo.users.findOne username: @user.username.toLowerCase(), (err, user) ->
      expect(user).to.not.have.property('password')
      expect(user).to.have.property('hashed_password')
      done()

  it 'should not create a new user with the same email', (done) ->
    @user.username = 'Someone.Else'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Duplicate Email'
      done()

  it 'should not create a new user with the same username', (done) ->
    @user.email = 'another@example.com'
    api.post '/users', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Duplicate Username'
      done()
