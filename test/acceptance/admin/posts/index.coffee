describe 'Admin Posts index', ->

  before (done) ->
    @browser.as_admin().visit('/admin/posts', done)

  before ->
    @main = @browser.query('main[role=main]')

  it 'should highlight the side nav', ->
    expect(@browser.text('nav .on')).to.equal 'Posts'

  it 'should have a search header', ->
    header = @browser.query('header', @main)
    expect(@browser.text('h1', header)).to.equal 'posts'
    expect(@browser.query('[data-action="create_model"]', header)).to.be.ok
    expect(@browser.query('[data-action="toggle_search"]', header)).to.be.ok
    expect(@browser.query('form[action="/search"]', header)).to.be.ok

  it 'should have a list of posts', ->
    list = @browser.queryAll('.model-list ul li', @main)
    expect(list).to.have.length 20
    for li in list
      expect(@browser.text('.title', li)).to.have.length.above(2)
      expect(@browser.text('time', li)).to.have.length.above(2)
