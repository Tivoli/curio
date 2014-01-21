zombie = require('zombie')

class global.Browser extends zombie

  constructor: (@user_cookie, @admin_cookie) ->
    @user_cookie  = @user_cookie.split('=')[1]
    @admin_cookie = @admin_cookie.split('=')[1]
    opts =
      site: 'http://localhost:3001'
      silent: true
    super(opts)

  as_user: ->
    @setCookie(name: 'connect.sid', value: @user_cookie)
    return this

  as_admin: ->
    @setCookie(name: 'connect.sid', value: @admin_cookie)
    return this

  reset_form: (form) ->
    for field in @queryAll('[name]', form)
      @fill(field, null)
    return this

  fill_form: (form, data) ->
    for k, v of data
      field = @query("[name=#{k}]", form)
      @fill(field, v)
    return this

  logout: ->
    @deleteCookies()
    return this
