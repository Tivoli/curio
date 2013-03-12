site = require('./site')

app.get '/js/templates.js', site.templates

# Default to load index
app.use site.index
