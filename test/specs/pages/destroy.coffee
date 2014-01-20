describe 'Pages DELETE destroy', ->

  before ->
    page  = require("#{@seeds}/pages")[30]
    @page = new Page(page).toJSON()

  it 'should not destroy a page without a user', (done) ->
    api.delete "/pages/#{@page.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should not destroy a page without an admin user', (done) ->
    api.delete "/pages/#{@page.id}", @user_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 401
      done()

  it 'should destroy a page with an admin user', (done) ->
    api.delete "/pages/#{@page.id}", @admin_cookie, (e, r, body) ->
      expect(r.statusCode).to.equal 200
      done()

  it 'should no longer exist', (done) ->
    api.get "/pages/#{@page.id}", (e, r, body) ->
      expect(r.statusCode).to.equal 404
      done()
