# Users
app.mongo.users.ensureIndex 'username', {unique: true}, ->
app.mongo.users.ensureIndex 'email', {unique: true}, ->

# Posts
app.mongo.posts.ensureIndex 'slug', {unique: true}, ->

# Pages
app.mongo.pages.ensureIndex 'path', {unique: true}, ->
app.mongo.pages.ensureIndex 'title', {unique: true}, ->

# Images
app.mongo.fs_files.ensureIndex 'metadata.type', ->
app.mongo.fs_files.ensureIndex 'metadata._id', ->
app.mongo.fs_chunks.ensureIndex {files_id: 1, n: 1}, {unique: true}, ->
