describe 'Users ALL roles', ->

  it 'should require a user to update a user role', (done) ->
    api.post '/users/52d803b02efbf50f93a8212c/roles', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require an admin user to update a user role', (done) ->
    api.post '/users/52d803b02efbf50f93a8212c/roles', @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require a role to add a role', (done) ->
    api.post '/users/52d803b02efbf50f93a8212c/roles', @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Role'
      done()

  it 'should add a role to a user', (done) ->
    api.post '/users/52d803b02efbf50f93a8212c/roles', {role: 'admin'}, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.is_admin).to.be.true
      done()

  it 'should remove a role from a user', (done) ->
    api.delete '/users/52d803b02efbf50f93a8212c/roles', {role: 'admin'}, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.is_admin).to.be.false
      done()
