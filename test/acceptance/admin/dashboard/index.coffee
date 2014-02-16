describe 'CMS index', ->

  it 'should require a user to access the admin', (done) ->
    @browser.logout().visit('/admin').then(=>
      expect(@browser.redirected).to.be.true
      expect(@browser.location.pathname).to.equal '/'
      return null
    ).then(done, done)

  it 'should require an admin user to access the admin', (done) ->
    @browser.as_user().visit('/admin').then(=>
      expect(@browser.redirected).to.be.true
      expect(@browser.location.pathname).to.equal '/'
      return null
    ).then(done, done)

  it 'should access the CMS as an admin', (done) ->
    @browser.as_admin().visit('/admin').then(=>
      expect(@browser.redirected).to.be.false
      expect(@browser.location.pathname).to.equal '/admin'
      return null
    ).then(done, done)
