describe 'Pages GET read', ->

  before ->
    page  = require("#{@seeds}/pages")[0]
    @page = new Page(page).toJSON()

  it 'should not find a page that does not exist', (done) ->
    api.get '/pages/invalid', (e, r, body) ->
      expect(r.statusCode).to.equal 404
      done()

  it 'should get a page by id', (done) ->
    api.get "/pages/#{@page.id}", (e, r, body) =>
      expect(body).to.deep.equal @page
      done()

  it 'should get a page by path', (done) ->
    api.get "/pages/#{@page.path}", (e, r, body) =>
      expect(body).to.deep.equal @page
      done()
