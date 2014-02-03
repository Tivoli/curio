AppRouter::routes =
  'cms':              'dashboard'
  'cms/users(/:id)':  'users'

App.router = new AppRouter

App.router.on 'route:dashboard', ->
  new App.views.Dashboard().render()

App.router.on 'route:users', (id) ->
  new App.views.Users().render()
