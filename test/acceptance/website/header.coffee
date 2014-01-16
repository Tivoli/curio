describe 'Website header', ->

  before ->
    @header = @browser.querySelector('header[role=banner]')

  xit 'should have the correct information in head', ->
    description = @browser.querySelector('meta[name=description]')
    expect(@browser.text('title')).to.equal 'ShopZaoZao'
    expect(description.getAttribute('content')).to.equal 'This is shop zaozao'
