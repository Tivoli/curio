describe 'SiteConfig website', ->

  before ->
    @website_config =
      id:             'website'
      title:          'My Site'
      description:    'This is a website description'
      blog_url:       'blog.example.com'
      facebook_url:   'https://facebook.com/example'
      twitter_url:    'https://twitter.com/example'
      instagram_url:  'https://instagram.com/example'
      pinterest_url:  'https://pinterest.com/example'

  it 'should not get a website config without a user', (done) ->
    api.get '/configs/website', (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not get a website config without an admin user', (done) ->
    api.get '/configs/website', @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should get an empty website config', (done) ->
    api.get '/configs/website', @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.id).to.equal 'website'
      done()

  it 'should update the website config', (done) ->
    api.put '/configs/website', @website_config, @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.deep.equal @website_config
      done()

  it 'should get the new website config', (done) ->
    api.get '/configs/website', @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body).to.deep.equal @website_config
      done()
