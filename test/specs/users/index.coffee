describe 'Users GET index', ->
  users = null

  it 'should not get users without being authed', (done) ->
    api.get '/users', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not get users without being an admin', (done) ->
    api.get '/users', @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should get a set of users as an admin', (done) ->
    api.get '/users', @admin_cookie, (e, r, body) ->
      expect(body.length).to.equal 20
      users = body
      done()

  it 'should get page 2 of users', (done) ->
    api.get '/users', {page: 2}, @admin_cookie, (e, r, body) ->
      expect(body.length).to.equal 20
      ids = (user.id for user in users)
      expect(_(body).every((user) -> not (user.id in ids))).to.be.true
      done()

  it 'should get a limited set of users', (done) ->
    api.get '/users', {limit: 5}, @admin_cookie, (e, r, body) ->
      expect(body.length).to.equal 5
      ids = (user.id for user in users.slice(0,5))
      expect(_(body).every((user) -> user.id in ids)).to.be.true
      done()

  it 'should get a limited set of users with pagination', (done) ->
    api.get '/users', {page: 2, limit: 5}, @admin_cookie, (e, r, body) ->
      expect(body.length).to.equal 5
      ids = (user.id for user in users.slice(4,10))
      expect(_(body).every((user) -> user.id in ids)).to.be.true
      done()

