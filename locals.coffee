# Anything that will be used on initial page render mostly for layouts

app.locals.title        = 'Node Boilerplate'
app.locals.description  = 'Node with cats'
app.locals.env          = app.get('env')
app.locals.js           = js('boiler')
app.locals.css          = css('boiler')
