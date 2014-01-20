describe 'Pages POST create', ->

  before ->
    @base_page = factory.page()

  beforeEach ->
    @page = _(@base_page).clone()

  it 'should require a user to create a page', (done) ->
    api.post '/pages', @page, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require an admin user to create a page', (done) ->
    api.post '/pages', @page, @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should require a path to create a page', (done) ->
    delete @page.path
    api.post '/pages', @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Path'
      done()

  it 'should require a title to create a page', (done) ->
    delete @page.title
    api.post '/pages', @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Title'
      done()

  it 'should require a context to create a page', (done) ->
    delete @page.context
    api.post '/pages', @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Missing Context'
      done()

  it 'should create a page', (done) ->
    api.post '/pages', @page, @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.path).to.equal @page.path
      expect(body.context).to.equal @page.context
      done()

  it 'should not create a page with the same path', (done) ->
    @page.title = 'Another title'
    api.post '/pages', @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Duplicate Path'
      done()

  it 'should not create a page with the same title', (done) ->
    @page.path = 'another-page'
    api.post '/pages', @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 400
      expect(body.error).to.equal 'Duplicate Title'
      done()
