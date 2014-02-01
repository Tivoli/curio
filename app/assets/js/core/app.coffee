window.App =
  models:       {}
  collections:  {}
  views:        {}
  mixins:       {}
  current:      []

  initialize: (opts={}) ->
    @user = new @models.User
    @listenTo @router, 'route:before', @route_before
    new @views.Header(el: $('header[role=banner]'), model: @user)
    Backbone.history.start(pushState: true)
    App.Api.get('/users/me').done (user) => @user.set(user)

  route_before: (route, name) ->
    $('html,body').animate({scrollTop: 0}, 0)
    view.remove() for view in @current

  remove_view: (view) ->
    @current = _(@current).reject (v) -> v.cid is view.cid
    return this

_(App).extend(Backbone.Events)
_(App).bindAll('remove_view')

$window   = $(window)
$document = $(document)

on_scroll = _.throttle (e) ->
  height  = $window.height()
  scroll  = $window.scrollTop()
  offset  = ($document.height() - height) - scroll
  App.trigger('app:scroll', e, offset)
, 10

on_resize = _.throttle (e) ->
  App.trigger('app:resize', e)
, 10

$ ->
  App.initialize()
  $window.on 'scroll', on_scroll
  $window.on 'resize', on_resize

