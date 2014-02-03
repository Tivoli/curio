window.App =
  models:       {}
  collections:  {}
  views:        {}
  mixins:       {}
  current:      []

  initialize: (opts={}) ->
    @user = new @models.User
    @listenTo(@router, 'route:before', @route_before)
    header = $('header[role=banner]')
    new @views.Header(el: header, model: @user) if header.length
    Backbone.history.start(pushState: true)
    App.Api.get('/users/me').done (user) => @user.set(user)

  route_before: (route, name) ->
    $('html,body').animate({scrollTop: 0}, 0)
    path    = Backbone.history.fragment
    anchor  = "a[href='/#{path}']"
    current = $("nav #{anchor}").addClass('on')
    $('nav a').not(current).removeClass('on')
    view.remove() for view in App.current

  remove_view: (view) ->
    @current = _(@current).reject (v) -> v.cid is view.cid
    return this

_(App).extend(Backbone.Events)
_(App).bindAll('remove_view')

$window   = $(window)
$document = $(document)
ticking   = false

scroll_update = ->
  offset  = ($document.height() - $window.height()) - $window.scrollTop()
  ticking = false
  App.trigger('app:scroll', offset)

on_scroll = ->
  unless ticking
    requestAnimationFrame(scroll_update)
    ticking = true

resize_update = ->
  ticking = false
  App.trigger('app:resize')

on_resize = ->
  unless ticking
    requestAnimationFrame(resize_update)
    ticking = true

$ ->
  App.initialize()
  $window
    .on('scroll', on_scroll)
    .on('resize', on_resize)

