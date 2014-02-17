describe 'Admin Users update', ->

  before (done) ->
    @browser.as_admin().visit('/admin/users').then =>
      @browser.clickLink('.model-list li:nth-child(5) a', done)

  before ->
    @main     = @browser.query('main[role=main]')
    @overlay  = @browser.query('#page_overlay')
    @form     = @browser.query('form', @overlay)
    @title    = @browser.query('[name=title]', @form)
    @context  = @browser.query('[name=context]', @form)

  it 'should add admin to a user', (done) ->
    @browser.check('is_admin').wait =>
      user_item = @browser.query('.model-list li:nth-child(5)', @main)
      expect(@browser.text('.admin', user_item)).to.equal 'Admin'
      done()

  it 'should remove admin from a user', (done) ->
    @browser.uncheck('is_admin').wait =>
      user_item = @browser.query('.model-list li:nth-child(5)', @main)
      expect(@browser.text('.admin', user_item)).to.equal ''
      done()
