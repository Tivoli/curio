crypto = require('crypto')

exports.policy = (aws) ->
  s3_policy =
    expiration: moment().add('minutes', 30).toISOString()
    conditions: [
      { bucket: aws.s3.bucket }
      { acl: "public-read" }
      { success_action_status: '201' }
      ["starts-with", "$key", ""]
      ["starts-with", "$Content-Type", ""]
    ]
  new Buffer(JSON.stringify(s3_policy)).toString('base64')

exports.signature = (aws, policy) ->
  crypto.createHmac('sha1', aws.secret).update(policy).digest('base64')
