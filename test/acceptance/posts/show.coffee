describe 'Posts acceptance show', ->

  before (done) ->
    post  = require("#{@seeds}/posts")[10]
    @post = new Post(post).toJSON()
    @browser.visit("/#{@post.slug}", done)

  before ->
    @main = @browser.querySelector('main[role=main]')

  it 'should have a page', ->
    expect(@main.querySelector('.grid-row')).to.be.ok
    expect(@main.querySelector('.grid-row .grid-unit.col-4')).to.be.ok

  it 'should be formatted with markdown', ->
    expect(@browser.text('h1'), @main).to.equal @post.title
    expect(@browser.text('p'), @main).to.equal 'Sit ad facere minima consequuntur quibusdam dolore voluptas ratione aspernatur quos doloremque omnis inventore assumenda. Voluptates eum nobis nostrum consectetur amet dolorem sed laboriosam dolor quo aut. Voluptatum veniam nihil.'
