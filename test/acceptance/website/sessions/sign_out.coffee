describe 'Website Sessions sign out', ->

  before (done) ->
    user =
      email: 'zombie5@example.com'
      password: 'wantsbrains'
    @browser.sign_in(user, done)

  before (done) ->
    @browser.visit('/', done)

  it 'should be signed in', ->
    expect(@browser.query('[data-modal=SessionModal]')).to.be.null
    expect(@browser.query('[data-modal=RegisterModal]')).to.be.null

  it 'should sign out', (done) ->
    @browser.visit('/logout').then(=>
      expect(@browser.redirected).to.be.true
      expect(@browser.location.pathname).to.equal '/'
      expect(@browser.query('[data-modal=SessionModal]')).to.be.ok
      expect(@browser.query('[data-modal=RegisterModal]')).to.be.ok
      return null
    ).then(done, done)
