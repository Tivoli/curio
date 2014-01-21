describe 'Mixins underscore', ->

  # ==== isEmail ====
  it 'should not validate an email without a string', ->
    expect(_(1).isEmail()).to.be.false
    expect(_(null).isEmail()).to.be.false
    expect(_(undefined).isEmail()).to.be.false
    expect(_(new Error('Invalid')).isEmail()).to.be.false
    expect(_({}).isEmail()).to.be.false
    expect(_([]).isEmail()).to.be.false

  it 'should not validate an invalid email', ->
    expect(_('invalid').isEmail()).to.be.false
    expect(_('invalid@example').isEmail()).to.be.false
    expect(_('invalid@example.c').isEmail()).to.be.false
    expect(_('inval!d@example.com').isEmail()).to.be.false

  it 'should validate an email', ->
    expect(_('valid@example.co').isEmail()).to.be.true
    expect(_('valid@example.com').isEmail()).to.be.true
    expect(_('valid.me@example.com').isEmail()).to.be.true
    expect(_('valid-me@example.com').isEmail()).to.be.true
    expect(_('valid_me@example.com').isEmail()).to.be.true
    expect(_('valid+me@example.com').isEmail()).to.be.true

  # ==== isUsername ====
  it 'should not validate a username without a string', ->
    expect(_(1).isUsername()).to.be.false
    expect(_(null).isUsername()).to.be.false
    expect(_(undefined).isUsername()).to.be.false
    expect(_(new Error('Invalid')).isUsername()).to.be.false
    expect(_({}).isUsername()).to.be.false
    expect(_([]).isUsername()).to.be.false

  it 'should not validate an invalid username', ->
    expect(_('inval!d').isUsername()).to.be.false
    expect(_('invalid name').isUsername()).to.be.false
    expect(_('').isUsername()).to.be.false
    expect(_('qwertyuiopasdfgh').isUsername()).to.be.false

  it 'should validate a username', ->
    expect(_('valid').isUsername()).to.be.true
    expect(_('valid.name').isUsername()).to.be.true
    expect(_('valid-name').isUsername()).to.be.true
    expect(_('valid_name').isUsername()).to.be.true
    expect(_('valid_name1').isUsername()).to.be.true

  # ==== isName ====
  it 'should not validate a name without a string', ->
    expect(_(1).isName()).to.be.false
    expect(_(null).isName()).to.be.false
    expect(_(undefined).isName()).to.be.false
    expect(_(new Error('Invalid')).isName()).to.be.false
    expect(_({}).isName()).to.be.false
    expect(_([]).isName()).to.be.false

  it 'should not validate an invalid name', ->
    expect(_('in').isName()).to.be.false

  it 'should validate a name', ->
    expect(_('name').isName()).to.be.true
    expect(_('my name').isName()).to.be.true
    expect(_('my name 1st').isName()).to.be.true
    expect(_('my name jr.').isName()).to.be.true

  # ==== isObjectID ====
  it 'should not validate an invalid objectid', ->
    expect(_(1).isObjectID()).to.be.false
    expect(_(null).isObjectID()).to.be.false
    expect(_(undefined).isObjectID()).to.be.false
    expect(_(new Error('Invalid')).isObjectID()).to.be.false
    expect(_({}).isObjectID()).to.be.false
    expect(_([]).isObjectID()).to.be.false
    expect(_('jMJnAGXYLpmK5HdVZQRb5gsR').isObjectID()).to.be.false

  it 'should validate an object id as a string or objectid', ->
    id = new app.mongo.ObjectID
    expect(_(id.toHexString()).isObjectID()).to.be.true
    expect(_(id).isObjectID()).to.be.true

  # ==== isSlug ====
  it 'should not validate a slug without a string', ->
    expect(_(1).isSlug()).to.be.false
    expect(_(null).isSlug()).to.be.false
    expect(_(undefined).isSlug()).to.be.false
    expect(_(new Error('Invalid')).isSlug()).to.be.false
    expect(_({}).isSlug()).to.be.false
    expect(_([]).isSlug()).to.be.false

  it 'should not validate an invalid slug', ->
    expect(_('invalid slug').isSlug()).to.be.false
    expect(_('invalid.slug').isSlug()).to.be.false
    expect(_('invalid_slug').isSlug()).to.be.false
    expect(_('invalid!slug').isSlug()).to.be.false
    expect(_('Invalid-Slug').isSlug()).to.be.false

  it 'should validate a slug', ->
    expect(_('valid-slug').isSlug()).to.be.true
    expect(_('valid-slug-1').isSlug()).to.be.true

  # ==== isISODate ====
  it 'should not validate an ISO date without a string', ->
    expect(_(1).isISODate()).to.be.false
    expect(_(null).isISODate()).to.be.false
    expect(_(undefined).isISODate()).to.be.false
    expect(_(new Error('Invalid')).isISODate()).to.be.false
    expect(_({}).isISODate()).to.be.false
    expect(_([]).isISODate()).to.be.false

  it 'should not validate an invalid ISO date', ->
    expect(_().isISODate('invalid')).to.be.false
    expect(_().isISODate('2014-01-1821:21:15')).to.be.false
    expect(_().isISODate('2014-01-1821:21:15.000Z')).to.be.false

  it 'should validate an ISO date', ->
    expect(_('2014-01-18T21:21:15.000Z').isISODate()).to.be.true

  # ==== toSlug ====
  it 'should convert a string to a valid slug', ->
    expect(_('Test Slug 1').toSlug()).to.equal 'test-slug-1'
    expect(_('Test & Slug 1').toSlug()).to.equal 'test-slug-1'
    expect(_('  Test & Slug % 1  ').toSlug()).to.equal 'test-slug-1'
    expect(_('  Test-my & Slug % 1  ').toSlug()).to.equal 'test-my-slug-1'

  # ==== formatCurrency ====
  it 'should convert numbers to a readable USD format', ->
    expect(_(199).formatCurrency()).to.equal '$1.99'
    expect(_(10009999).formatCurrency()).to.equal '$100,099.99'
    expect(_(100009999).formatCurrency()).to.equal '$1,000,099.99'

  # ==== subdomain ====
  it 'should not get a subdomain without a string', ->
    expect(_(1).subdomain()).to.not.be.ok
    expect(_(null).subdomain()).to.not.be.ok
    expect(_(undefined).subdomain()).to.not.be.ok
    expect(_(new Error('Invalid')).subdomain()).to.not.be.ok
    expect(_({}).subdomain()).to.not.be.ok
    expect(_([]).subdomain()).to.not.be.ok

  it 'should not get a subdomain for zone apex or www from a url', ->
    expect(_('http://example.com').subdomain()).to.not.be.ok
    expect(_('https://example.com').subdomain()).to.not.be.ok
    expect(_('http://www.example.com').subdomain()).to.not.be.ok
    expect(_('https://www.example.com').subdomain()).to.not.be.ok

  it 'should get the subdomain from a url', ->
    expect(_('http://sub.example.com').subdomain()).to.equal 'sub'
    expect(_('https://sub.example.com').subdomain()).to.equal 'sub'
