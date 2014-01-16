nock = require('nock')

nock('https://graph.facebook.com')
  .filteringPath(/access_token=[^&]*/g, 'access_token=XXX')
  .get("/me?access_token=XXX").replyWithFile(200, "#{__dirname}/fakes/facebook.json")
  .get("/me?access_token=XXX").replyWithFile(200, "#{__dirname}/fakes/facebook.json")
  .get("/me?access_token=XXX").replyWithFile(200, "#{__dirname}/fakes/facebook.json")
