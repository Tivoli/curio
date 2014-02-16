describe 'Website acceptance index', ->

  before (done) ->
    @browser.as_admin().visit('/admin/settings', done)

  before ->
    @main   = @browser.query('main[role=main]')
    @ribbon = @browser.query('aside[role=complementary]')

  it 'should highlight the side nav', ->
    expect(@browser.text('.on', @ribbon)).to.equal 'Settings'

  it 'should have a site config', ->
    module = @browser.query('[data-view=SiteConfig]', @main)
    expect(@browser.query('[name=title]', module).value).to.equal 'My Site'
    expect(@browser.query('[name=description]', module).value).to.equal 'This is a website description'
