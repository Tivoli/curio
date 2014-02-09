describe 'Uploads GET cors', ->

  it 'should not get cors without a user', (done) ->
    api.get '/uploads/cors', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not get cors without an admin user', (done) ->
    api.get '/uploads/cors', @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should get cors data', (done) ->
    api.get '/uploads/cors', @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.short_id).to.have.length 10
      expect(body).to.have.property('access_key')
      expect(body).to.have.property('bucket')
      expect(body).to.have.property('policy')
      expect(body).to.have.property('signature')
      done()
