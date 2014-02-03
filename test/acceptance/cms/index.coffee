describe 'CMS index', ->

  it 'should require a user to access the cms', (done) ->
    @browser.logout().visit('/cms').then(=>
      expect(@browser.redirected).to.be.true
      expect(@browser.location.pathname).to.equal '/'
      return null
    ).then(done, done)

  it 'should require an admin user to access the cms', (done) ->
    @browser.as_user().visit('/cms').then(=>
      expect(@browser.redirected).to.be.true
      expect(@browser.location.pathname).to.equal '/'
      return null
    ).then(done, done)

  it 'should access the CMS as an admin', (done) ->
    @browser.as_admin().visit('/cms').then(=>
      expect(@browser.redirected).to.be.false
      expect(@browser.location.pathname).to.equal '/cms'
      return null
    ).then(done, done)
