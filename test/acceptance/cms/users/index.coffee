describe 'Users acceptance index', ->

  before (done) ->
    @browser.as_admin().visit('/cms/users', done)

  before ->
    @main   = @browser.query('main[role=main]')
    @ribbon = @browser.query('aside[role=complementary]')

  it 'should highlight the side nav', ->
    expect(@browser.text('.on', @ribbon)).to.equal 'Users'

  it 'should have a search header', ->
    header = @browser.query('header', @main)
    expect(@browser.text('h1', header)).to.equal 'users'
    expect(@browser.query('form[action="/search"]', header)).to.be.ok

  it 'should have a list of users', ->
    expect(@browser.queryAll('ul li', @main)).to.have.length 20
