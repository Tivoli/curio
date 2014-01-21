describe 'Users register', ->

  before (done) ->
    @base_user = factory.user()
    @browser.logout().visit('/', done)

  before (done) ->
    @header = @browser.querySelector('header[role=banner]')
    @browser.clickLink('a[data-modal=RegisterModal]', done)

  before ->
    @modal      = @browser.query('#register_modal')
    @form       = @browser.query('form', @modal)
    @name       = @browser.query('[name=name]', @form)
    @username   = @browser.query('[name=username]', @form)
    @email      = @browser.query('[name=email]', @form)
    @password   = @browser.query('[name=password]', @form)

  beforeEach ->
    @user = _(@base_user).clone()
    @browser.reset_form(@form)

  it 'should not register with missing information', (done) ->
    @browser.pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.equal 'error'
      expect(@username.getAttribute('class')).to.equal 'error'
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should not register with a missing name', (done) ->
    delete @user.name
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.equal 'error'
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with an invalid name', (done) ->
    @user.name = 'inva!id'
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.equal 'error'
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with a missing username', (done) ->
    delete @user.username
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.equal 'error'
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with an invalid username', (done) ->
    @user.username = 'n'
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.equal 'error'
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with a missing email', (done) ->
    delete @user.email
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with an invalid email', (done) ->
    @user.email = 'invalid@mail'
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.equal 'error'
      expect(@password.getAttribute('class')).to.be.null
      return null
    ).then(done, done)

  it 'should not register with a missing password', (done) ->
    delete @user.password
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should not register with an invalid password', (done) ->
    @user.password = '12345'
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@name.getAttribute('class')).to.be.null
      expect(@username.getAttribute('class')).to.be.null
      expect(@email.getAttribute('class')).to.be.null
      expect(@password.getAttribute('class')).to.equal 'error'
      return null
    ).then(done, done)

  it 'should register a new user', (done) ->
    @browser.fill_form(@form, @user).pressButton('Sign Up').then(=>
      expect(@browser.query('#register_modal')).to.be.null
      expect(@browser.query('[data-modal=SessionModal]', @header)).to.be.null
      expect(@browser.query('[data-modal=RegisterModal]', @header)).to.be.null
      return null
    ).then(done, done)
