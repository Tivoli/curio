describe 'Sessions GET token', ->

  before ->
    @user =
      email: 'zombie100@example.com'

  it 'should require an email to reset password', (done) ->
    api.post '/users/resetpassword', (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing or Invalid Email'
      done()

  it 'should not reset with an invalid email', (done) ->
    api.post '/users/resetpassword', {email: 'invalid'}, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing or Invalid Email'
      done()

  it 'should not reset with a non existent user', (done) ->
    api.post '/users/resetpassword', {email: 'invalid@example.com'}, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Cannot find User'
      done()

  it 'should send a reset with a valid email', (done) ->
    api.post '/users/resetpassword', @user, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      done()

  it 'should not sign in with a missing token', (done) ->
    api.get '/sessions/token', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not sign in with an invalid token', (done) ->
    api.get '/sessions/token', {token: 'invalid'}, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should sign in with a valid token', (done) ->
    app.redis.keys 'reset:*', (err, keys) ->
      token = _(keys).first().split(':')[1]
      api.get '/sessions/token', {token: token}, (e, r, body) ->
        expect(r.statusCode).to.equal 200
        done()
