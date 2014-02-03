AppRouter::routes =
  'cms':              'dashboard'
  'cms/users(/:id)':  'users'
  'cms/posts(/:id)':  'posts'

App.router = new AppRouter

App.router.on 'route:dashboard', ->
  new App.views.Dashboard().render()

App.router.on 'route:users', (id) ->
  new App.views.Users().render()

App.router.on 'route:posts', (id) ->
  new App.views.Posts().render()
