describe 'Website header', ->

  before (done) ->
    @browser.logout().visit('/', done)

  before ->
    @header = @browser.query('header[role=banner]')

  it 'should have the correct information in head', ->
    description = @browser.query('meta[name=description]')
    expect(@browser.text('title')).to.equal 'My Site'
    expect(description.getAttribute('content')).to.equal 'This is a website description'

  it 'should have a link to home', ->
    expect(@browser.query('a[href="/"]', @header)).to.be.ok

  it 'should have a logged out header', ->
    expect(@browser.query('a[data-modal=SignInModal]', @header)).to.be.ok
    expect(@browser.query('a[data-modal=RegisterModal]', @header)).to.be.ok
