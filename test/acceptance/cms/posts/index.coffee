describe 'Posts acceptance index', ->

  before (done) ->
    @browser.as_admin().visit('/cms/posts', done)

  before ->
    @main   = @browser.query('main[role=main]')
    @ribbon = @browser.query('aside[role=complementary]')

  it 'should highlight the side nav', ->
    expect(@browser.text('.on', @ribbon)).to.equal 'Posts'

  it 'should have a search header', ->
    header = @browser.query('header', @main)
    expect(@browser.text('h1', header)).to.equal posts
    expect(@browser.query('form[action="/search"]', header)).to.be.ok

  it 'should have a list of posts', ->
    list = @browser.queryAll('ul li', @main)
    expect(list).to.have.length 20
    for li in list
      expect(@browser.query('time', li)).to.be.ok
