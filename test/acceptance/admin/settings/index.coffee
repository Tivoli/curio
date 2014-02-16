describe 'Website acceptance index', ->

  before (done) ->
    @settings =
      title:        'Curio'
      description:  'This is curio'
    @browser.as_admin().visit('/admin/settings', done)

  before ->
    @main   = @browser.query('main[role=main]')
    @form   = @browser.query('form', @main)
    @ribbon = @browser.query('aside[role=complementary]')

  it 'should highlight the side nav', ->
    expect(@browser.text('.on', @ribbon)).to.equal 'Settings'

  it 'should have a site config', ->
    module = @browser.query('[data-view=SiteConfig]', @main)
    expect(@browser.query('[name=title]', module).value).to.equal 'My Site'
    expect(@browser.query('[name=description]', module).value).to.equal 'This is a website description'

  it 'should update site settings', (done) ->
    @browser.fill_form(@form, @settings).pressButton 'Update', =>
      @browser.visit('/').then(=>
        description = @browser.query('meta[name=description]')
        expect(@browser.text('title')).to.equal @settings.title
        expect(description.getAttribute('content')).to.equal @settings.description
        return null
      ).then(done, done)
