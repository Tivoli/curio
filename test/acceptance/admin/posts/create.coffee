describe 'CMS Posts create', ->

  before (done) ->
    @base_post = factory.post()
    @browser.as_admin().visit('/admin/posts', done)

  before (done) ->
    @browser.clickLink('[data-action="create_model"]', done)

  before ->
    @main     = @browser.query('main[role=main]')
    @overlay  = @browser.query('#post_overlay')
    @form     = @browser.query('form', @overlay)
    @title    = @browser.query('[name=title]', @form)
    @context  = @browser.query('[name=context]', @form)

  beforeEach ->
    @post = _(@base_post).clone()
    @browser.reset_form(@form)

  it 'should not create a post with missing information', (done) ->
    @browser.pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.contain 'error'
      expect(@context.getAttribute('class')).to.contain 'error'
      return null
    ).then(done, done)

  it 'should not create a post with a missing title', (done) ->
    delete @post.title
    @browser.fill_form(@form, @post).pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.contain 'error'
      expect(@context.getAttribute('class')).to.not.contain 'error'
      return null
    ).then(done, done)

  it 'should not create a post with a missing context', (done) ->
    delete @post.context
    @browser.fill_form(@form, @post).pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.not.contain 'error'
      expect(@context.getAttribute('class')).to.contain 'error'
      return null
    ).then(done, done)

  it 'should create a new post', (done) ->
    @browser.fill_form(@form, @post).pressButton('Publish').then(=>
      expect(@browser.query('#post_overlay')).to.be.null
      post_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', post_item)).to.equal @post.title
      expect(@browser.query('time', post_item)).to.be.ok
      return null
    ).then(done, done)
