root_dir = "#{__dirname}"

# Connect, Clear, and seed database for testing
before (done) ->
  async.series
    connect: (fn) -> db.connect(fn)
    clear: (fn) -> db.clear(fn)
    seed: (fn) -> db.seed(fn)
  , done

# Local vars available to individual tests
before (done) ->
  @seeds  = "#{root_dir}/../server/db/data/seeds"
  users   = require("#{@seeds}/users")
  admin   = _(users).find (u) -> 'admin' in (u.roles or [])
  user    = _(users).find (u) -> 'admin' not in (u.roles or [])
  async.parallel
    admin: (fn) ->
      api.post '/sessions', {email: admin.email, password: 'wantsbrains'}, (e, r, body) ->
        fn(null, r.headers['set-cookie'].pop().split(';')[0])
    user: (fn) ->
      api.post '/sessions', {email: user.email, password: 'wantsbrains'}, (e, r, body) ->
        fn(null, r.headers['set-cookie'].pop().split(';')[0])
  , (err, results) =>
    @admin_cookie = results.admin
    @user_cookie = results.user
    done()

# Create a shared browser
before ->
  @browser = new Browser(@user_cookie, @admin_cookie)

# Destroy the browser after all tests
after ->
  @browser.destroy()
