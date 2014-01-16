# Users
app.mongo.users.ensureIndex 'username', {unique: true}, ->
app.mongo.users.ensureIndex 'email', {unique: true}, ->

# Images
app.mongo.fs_files.ensureIndex 'metadata.type', ->
app.mongo.fs_files.ensureIndex 'metadata._id', ->
app.mongo.fs_chunks.ensureIndex {files_id: 1, n: 1}, {unique: true}, ->
