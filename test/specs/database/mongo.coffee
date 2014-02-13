describe 'Mongo', ->

  it 'should have indexes on the users collection', (done) ->
    curio.mongo.users.indexInformation (err, index) ->
      expect(index).to.include.keys('email_1')
      expect(index).to.include.keys('username_1')
      done()

  it 'should have indexes on the posts collection', (done) ->
    curio.mongo.posts.indexInformation (err, index) ->
      expect(index).to.include.keys('slug_1')
      done()

  it 'should have indexes on the pages collection', (done) ->
    curio.mongo.pages.indexInformation (err, index) ->
      expect(index).to.include.keys('path_1')
      expect(index).to.include.keys('title_1')
      done()
