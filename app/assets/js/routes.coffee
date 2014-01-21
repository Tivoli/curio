App.router.on 'route:before', (route, name) ->
  $('html,body').animate({scrollTop: 0}, 0)
  view.remove() for view in App.current

App.router.on 'route:home', ->
  new App.views.Home().render()
