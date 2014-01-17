describe 'Users PUT update', ->

  before (done) ->
    api.post '/sessions', {email: 'zombie200@example.com', password: 'wantsbrains'}, (e, r, body) =>
      @cookie = r.headers['set-cookie'].pop().split(';')[0]
      @base_user = body
      done()

  beforeEach ->
    @user = _(@base_user).clone()

  it 'should not update a user', (done) ->
    api.put "/users/#{@user.id}", @user, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not update a different user', (done) ->
    api.put "/users/#{@user.id}", @user, @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not update with a bad email', (done) ->
    @user.email = 'invalid.com'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Email'
      done()

  it 'should update a user email', (done) ->
    @user.email = 'new_zombie@example.com'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.email).to.equal 'new_zombie@example.com'
      expect(body).to.deep.equal @user
      @base_user = body
      done()

  it 'should not update with a bad name', (done) ->
    @user.name = 'Inval!d N@me'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Name'
      done()

  it 'should update a user name', (done) ->
    @user.name = 'Westley Pierre'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.name).to.equal 'Westley Pierre'
      expect(body).to.deep.equal @user
      @base_user = body
      done()

  it 'should not update with a bad username', (done) ->
    @user.username = 'inval!d'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Username'
      done()

  it 'should not update with a reserved username', (done) ->
    @user.username = 'admin'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Invalid Username'
      done()

  it 'should update a username', (done) ->
    @user.username = 'wpierre'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.username).to.equal 'wpierre'
      expect(body).to.deep.equal @user
      @base_user = body
      done()

  it 'should not update an invalid password', (done) ->
    @user.password = 'short'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Password too short'
      done()

  it 'should update a password', (done) ->
    @user.password = 'password'
    api.put "/users/#{@user.id}", @user, @cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      delete @user.password
      expect(body).to.deep.equal @user
      expect(body).to.not.have.property 'password'
      done()

  it 'should not sign in with old password', (done) ->
    api.post '/sessions', {email: @user.email, password: 'wantsbrains'}, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should sign in with new password', (done) ->
    api.post '/sessions', {email: @user.email, password: 'password'}, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.deep.equal @user
      done()
