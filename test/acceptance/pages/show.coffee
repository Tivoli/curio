describe 'Pages acceptance show', ->

  before (done) ->
    page  = require("#{@seeds}/pages")[10]
    @page = new Page(page).toJSON()
    @browser.visit("/#{@page.path}", done)

  before ->
    @main = @browser.query('main[role=main]')

  it 'should have a page', ->
    expect(@browser.query('.grid-row', @main)).to.be.ok
    expect(@browser.query('.grid-row .grid-unit.col-4', @main)).to.be.ok

  it 'should be formatted with markdown', ->
    expect(@browser.text('h1'), @main).to.equal 'Sit ea adipisci.'
    expect(@browser.text('p'), @main).to.equal 'Sit accusantium quia totam unde?'
    list = @browser.queryAll('ul li', @main)
    expect(list).to.have.length 2
    expect(item.innerHTML).to.equal('Consectetur.') for item in list
