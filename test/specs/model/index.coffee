describe 'Model', ->
  mongo = curio.mongo

  describe 'strToID', ->
    it 'should convert a string to an object id', ->
      id = '52d8d736b394b01c4e9aa8a8'
      expect(Model.strToID(id)).to.be.instanceof mongo.ObjectID

    it 'should preserve an object id', ->
      id = new mongo.ObjectID('52d8d736b394b01c4e9aa8a8')
      converted = Model.strToID(id)
      expect(converted).to.be.instanceof mongo.ObjectID
      expect(converted.equals(id)).to.be.ok

    it 'should not convert an invalid id', ->
      id = 'invalid'
      expect(Model.strToID(id)).to.be.a 'string'
      expect(Model.strToID(id)).to.equal id

  describe 'dateToID', ->
    it 'should convert a date to an object id', ->
      date = new Date('2013-08-01T08:01:00')
      expect(Model.dateToID(date)).to.be.instanceof mongo.ObjectID

    it 'should convert a number to an object id', ->
      expect(Model.dateToID(1)).to.be.instanceof mongo.ObjectID

  describe 'Find', ->
    it 'should not find a model with a null id', (done) ->
      User.find null, (err, user) ->
        expect(err.message).to.equal 'Missing query param for User'
        done()

    it 'should not find a model with an invalid id', (done) ->
      User.find 'inval!d', (err, user) ->
        expect(err.message).to.equal 'Missing query param for User'
        done()
