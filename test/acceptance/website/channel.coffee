describe 'Website channel.html', ->

  it 'should have a facebook channel file', (done) ->
    @browser.visit('/channel.html').then(=>
      expect(@browser.html()).to.contain 'id=\"fb-root\"'
      return null
    ).then(done, done)
