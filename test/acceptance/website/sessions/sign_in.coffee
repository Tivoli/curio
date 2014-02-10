describe 'Sessions sign in', ->

  before (done) ->
    @base_user =
      email:    'zombie1@example.com'
      password: 'wantsbrains'
    @browser.logout().visit('/', done)

  before (done) ->
    @header = @browser.query('header[role=banner]')
    @browser.clickLink('a[data-modal=SessionModal]', done)

  before ->
    @modal    = @browser.query('#session_modal')
    @form     = @browser.query('form', @modal)
    @email    = @browser.query('[name=email]', @form)
    @password = @browser.query('[name=password]', @form)

  beforeEach ->
    @user = _(@base_user).clone()
    @browser.reset_form(@form)

  it 'should not sign in with missing information', (done) ->
    @browser.pressButton('Sign In').then(=>
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should not sign in with a missing email', (done) ->
    delete @user.email
    @browser.fill_form(@form, @user).pressButton('Sign In').then(=>
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not sign in with a bad email', (done) ->
    @user.email = 'invalid@example'
    @browser.fill_form(@form, @user).pressButton('Sign In').then(=>
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not sign in with a missing password', (done) ->
    delete @user.password
    @browser.fill_form(@form, @user).pressButton('Sign In').then(=>
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should not sign in with a bad password', (done) ->
    @user.password = '12345'
    @browser.fill_form(@form, @user).pressButton('Sign In').then(=>
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should sign in with correct information', (done) ->
    @browser.fill_form(@form, @user).pressButton('Sign In').then(=>
      expect(@browser.query('#sign_in_modal')).to.be.null
      expect(@browser.query('[data-modal=SessionModal]', @header)).to.be.null
      expect(@browser.query('[data-modal=RegisterModal]', @header)).to.be.null
      return null
    ).then(done, done)
