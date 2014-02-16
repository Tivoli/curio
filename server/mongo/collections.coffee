module.exports = (app) ->
  mongo = app.mongo

  # Configs
  mongo.configs = mongo.db.collection('configs')

  # Users
  mongo.users = mongo.db.collection('users')
  mongo.users.ensureIndex 'username', {unique: true}, ->
  mongo.users.ensureIndex 'email', {unique: true}, ->

  # Posts
  mongo.posts = mongo.db.collection('posts')
  mongo.posts.ensureIndex 'slug', {unique: true}, ->

  # Pages
  mongo.pages = mongo.db.collection('pages')
  mongo.pages.ensureIndex 'path', {unique: true}, ->
  mongo.pages.ensureIndex 'title', {unique: true}, ->

  # Tokens
  mongo.tokens = mongo.db.collection('tokens')
  mongo.tokens.ensureIndex {expires: 1}, {expireAfterSeconds: 86400 * 2}, ->
