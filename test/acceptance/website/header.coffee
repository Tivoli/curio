describe 'Website header', ->

  before (done) ->
    @browser.visit('/', done)

  before ->
    @header = @browser.querySelector('header[role=banner]')

  it 'should have the correct information in head', ->
    description = @browser.querySelector('meta[name=description]')
    expect(@browser.text('title')).to.equal 'My Site'
    expect(description.getAttribute('content')).to.equal 'This is a website description'
