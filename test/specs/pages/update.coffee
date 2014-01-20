describe 'Pages PUT update', ->

  before ->
    page        = require("#{@seeds}/pages")[50]
    @base_page  = new Page(page).toJSON()

  beforeEach ->
    @page = _(@base_page).clone()

  it 'should not update a page without a user', (done) ->
    api.put "/pages/#{@page.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not update a page without an admin user', (done) ->
    api.put "/pages/#{@page.id}", @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should update a page path', (done) ->
    @page.path = 'new-page-path'
    api.put "/pages/#{@page.id}", @page, @admin_cookie, (e, r, body) =>
      expect(r.statusCode).to.equal 200
      expect(body.path).to.equal 'new-page-path'
      @base_page = body
      done()

  it 'should update a page context', (done) ->
    @page.context = 'Updated page context'
    api.put "/pages/#{@page.id}", @page, @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      expect(body.path).to.equal 'new-page-path'
      expect(body.context).to.equal 'Updated page context'
      done()
