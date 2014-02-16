nock = require('nock')

nock('https://graph.facebook.com')
  .persist()
  .filteringPath(/access_token=[^&]*/g, 'access_token=XXX')
  .get("/me?access_token=XXX").replyWithFile(200, "#{__dirname}/fakes/facebook.json")

nock('http://connect.facebook.net')
  .persist()
  .get('/en_US/all.js').replyWithFile(200, "#{__dirname}/fakes/all.js")

nock('http://s3.amazonaws.com')
  .persist()
  .get('/curio/images/image').replyWithFile(200, "#{__dirname}/fakes/image.jpg")
