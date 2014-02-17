describe 'Admin Posts update', ->

  before (done) ->
    @browser.as_admin().visit('/admin/posts', done)

  before ->
    @main     = @browser.query('main[role=main]')
    @overlay  = @browser.query('#post_overlay')
    @form     = @browser.query('form', @overlay)
    @title    = @browser.query('[name=title]', @form)
    @context  = @browser.query('[name=context]', @form)

  beforeEach (done) ->
    @browser.clickLink('.model-list li:first-of-type a', done)

  it 'should update a post title', (done) ->
    @browser.fill('title', 'A New Title').pressButton('Update').then(=>
      expect(@browser.query('#post_overlay')).to.be.null
      post_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', post_item)).to.equal 'A New Title'
      return null
    ).then(done, done)

  it 'should update a post context', (done) ->
    @browser.fill('context', 'Updated page content').pressButton('Update').then(=>
      expect(@browser.query('#post_overlay')).to.be.null
      post_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', post_item)).to.equal 'A New Title'
      return null
    ).then(done, done)
