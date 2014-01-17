describe 'Users GET read', ->

  it 'should not find a user that does not exist', (done) ->
    api.get '/users/invalid', (e, r, body) ->
      expect(r.statusCode).to.equal 404
      done()

  it 'should get a user by id', (done) ->
    api.get '/users/52d803b02efbf50f93a8210f', (e, r, body) ->
      expect(body.id).to.equal '52d803b02efbf50f93a8210f'
      expect(body.name).to.equal 'Dread Pirate'
      expect(body.username).to.equal 'Zombie1'
      expect(body).to.not.have.property 'email'
      done()

  it 'should get a user by username', (done) ->
    api.get '/users/zombie1', (e, r, body) ->
      expect(body.id).to.equal '52d803b02efbf50f93a8210f'
      expect(body.name).to.equal 'Dread Pirate'
      expect(body.username).to.equal 'Zombie1'
      expect(body).to.not.have.property 'email'
      done()

  it 'should get a full user when requesting themself', (done) ->
    api.get '/users/zombie2', @user_cookie, (e, r, body) ->
      expect(body.id).to.equal '52d803b02efbf50f93a82110'
      expect(body.name).to.equal 'Dread Pirate'
      expect(body.username).to.equal 'Zombie2'
      expect(body.email).to.equal 'zombie2@example.com'
      done()

  it 'should not get a user without being logged in', (done) ->
    api.get '/users/me', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should get a full user', (done) ->
    api.get '/users/me', @user_cookie, (e, r, body) ->
      expect(body.id).to.equal '52d803b02efbf50f93a82110'
      expect(body.name).to.equal 'Dread Pirate'
      expect(body.username).to.equal 'Zombie2'
      expect(body.email).to.equal 'zombie2@example.com'
      done()
