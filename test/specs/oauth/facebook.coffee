describe "Oauth POST create", ->

  beforeEach ->
    @fb_user =
      uid:    "100003598174190"
      token:  "AAADqDUAajYUBAFmBYAxtN0rFshL6k7GXCWo8SA5KhZCKaeFit6EsiXtMIWZBQbtSbEgbGXkHZAZA6hXnwMDts3YAy6qtSZBrHBEOrA7AyowZDZD"

  it 'should not log in to oauth without a uid', (done) ->
    delete @fb_user.uid
    api.post '/oauth/facebook', @fb_user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing UID'
      done()

  it 'should not log in to oauth without a token', (done) ->
    delete @fb_user.token
    api.post '/oauth/facebook', @fb_user, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Token'
      done()

  it 'should create a user with facebook', (done) ->
    api.post '/oauth/facebook', @fb_user, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.have.property('id')
      expect(body.email).to.match /tfbnw.net$/
      expect(body.username).to.equal 'Bokoru.Nokoru'
      expect(body.name).to.equal 'Bokoru Nokoru'
      expect(body).to.not.have.property('password')
      @user = body
      done()

  it 'should log in using facebook with an existing user', (done) ->
    api.post '/oauth/facebook', @fb_user, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.deep.equal(@user)
      done()
