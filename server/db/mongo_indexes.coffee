# Users
app.mongo.users.ensureIndex 'username', {unique: true}, ->
app.mongo.users.ensureIndex 'email', {unique: true}, ->

# Posts
app.mongo.posts.ensureIndex 'slug', {unique: true}, ->

# Pages
app.mongo.pages.ensureIndex 'path', {unique: true}, ->
app.mongo.pages.ensureIndex 'title', {unique: true}, ->
