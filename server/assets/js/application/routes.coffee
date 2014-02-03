AppRouter::routes =
  '':       'home'
  '*path':  'pages'

App.router = new AppRouter

App.router.on 'route:home', ->
  new App.views.Home().render()
