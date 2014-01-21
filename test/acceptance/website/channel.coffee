describe 'Website channel.html', ->

  it 'should have a facebook channel file', (done) ->
    @browser.visit('/channel.html').then(=>
      expect(@browser.window.FB).to.be.ok
      return null
    ).then(done, done)
