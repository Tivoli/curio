describe 'Admin Pages create', ->

  before (done) ->
    @base_page = factory.page()
    @browser.as_admin().visit '/admin/pages', =>
      @browser.clickLink('[data-action="create_model"]', done)

  before ->
    @main     = @browser.query('main[role=main]')
    @overlay  = @browser.query('#page_overlay')
    @form     = @browser.query('form', @overlay)
    @title    = @browser.query('[name=title]', @form)
    @path     = @browser.query('[name=path]', @form)
    @context  = @browser.query('[name=context]', @form)

  beforeEach ->
    @page = _(@base_page).clone()
    @browser.reset_form(@form)

  it 'should not create a page with missing information', (done) ->
    @browser.pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.contain 'error'
      expect(@path.getAttribute('class')).to.contain 'error'
      expect(@context.getAttribute('class')).to.contain 'error'
      return null
    ).then(done, done)

  it 'should not create a page with a missing title', (done) ->
    delete @page.title
    @browser.fill_form(@form, @page).pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.contain 'error'
      expect(@path.getAttribute('class')).to.not.contain 'error'
      expect(@context.getAttribute('class')).to.not.contain 'error'
      return null
    ).then(done, done)

  it 'should not create a page with a missing path', (done) ->
    delete @page.path
    @browser.fill_form(@form, @page).pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.not.contain 'error'
      expect(@path.getAttribute('class')).to.contain 'error'
      expect(@context.getAttribute('class')).to.not.contain 'error'
      return null
    ).then(done, done)

  it 'should not create a page with a missing context', (done) ->
    delete @page.context
    @browser.fill_form(@form, @page).pressButton('Publish').then(=>
      expect(@title.getAttribute('class')).to.not.contain 'error'
      expect(@path.getAttribute('class')).to.not.contain 'error'
      expect(@context.getAttribute('class')).to.contain 'error'
      return null
    ).then(done, done)

  it 'should create a new page', (done) ->
    @browser.fill_form(@form, @page).pressButton('Publish').then(=>
      expect(@browser.query('#page_overlay')).to.be.null
      page_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', page_item)).to.equal @page.title
      expect(@browser.text('.path', page_item)).to.equal @page.path
      return null
    ).then(done, done)
