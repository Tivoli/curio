describe 'Admin Pages index', ->

  before (done) ->
    @browser.as_admin().visit('/admin/pages', done)

  before ->
    @main = @browser.query('main[role=main]')

  it 'should highlight the side nav', ->
    expect(@browser.text('nav .on')).to.equal 'Pages'

  it 'should have a search header', ->
    header = @browser.query('header', @main)
    expect(@browser.text('h1', header)).to.equal 'pages'
    expect(@browser.query('[data-action="create_model"]', header)).to.be.ok
    expect(@browser.query('[data-action="toggle_search"]', header)).to.be.ok
    expect(@browser.query('form[action="/search"]', header)).to.be.ok

  it 'should have a list of pages', ->
    list = @browser.queryAll('.model-list ul li', @main)
    expect(list).to.have.length 20
    for li in list
      expect(@browser.text('.title', li)).to.have.length.above(2)
      expect(@browser.text('.path', li)).to.have.length.above(2)
