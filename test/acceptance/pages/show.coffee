describe 'Pages acceptance show', ->

  before (done) ->
    page  = require("#{@seeds}/pages")[10]
    @page = new Page(page).toJSON()
    @browser.visit("/#{@page.path}", done)

  before ->
    @main = @browser.querySelector('main[role=main]')

  it 'should have a page', ->
    expect(@main.querySelector('.grid-row')).to.be.ok
    expect(@main.querySelector('.grid-row .grid-unit.col-4')).to.be.ok

  it 'should be formatted with markdown', ->
    expect(@browser.text('h1'), @main).to.equal 'Sit ea adipisci.'
    expect(@browser.text('p'), @main).to.equal 'Sit accusantium quia totam unde?'
    list = @main.querySelectorAll('ul li')
    expect(list).to.have.length 2
    expect(item.innerHTML).to.equal('Consectetur.') for item in list
