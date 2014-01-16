zombie = require('zombie')

class global.Browser extends zombie

  constructor: ->
    opts =
      site: 'http://localhost:3001'
      silent: true
    super(opts)

  fill_form: (form, data) ->
    for k, v of data
      field = form.querySelector("[name=#{k}]")
      @fill(field, v)
    return this

  logout: (done) ->
    @deleteCookies()
    @visit('/', done)
