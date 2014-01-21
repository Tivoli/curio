class App.View extends Backbone.View

  action_events:
    'submit [data-action=subscribe]': 'form_subscribe'

  events: ->
    _.extend {}, @dom_events, @action_events, @overlay_events

  signup: (e) ->
    FB.login (res) =>
      return unless res.authResponse?
      body =
        uid: res.authResponse.userID
        token: res.authResponse.accessToken
      App.Api.post('/oauth/facebook', body).done (user) =>
        App.user.set(user)
        @remove()
    , {scope: 'email,publish_stream'}

  stop_propagation: (e) ->
    e.stopPropagation() unless e.should_continue

  in_view: ->
    $.contains(document.documentElement, @$el[0])

  append: ->
    @$el.appendTo(@append_to or $('[role=main]')) unless @in_view()
    for child in @$('[data-view]')
      el = $(child)
      new App.views[el.data('view')](el: el).render()
    @trigger('view:render')

  remove: ->
    @trigger('view:remove')
    @stopListening()
    App.remove_view(this)
    $('body').removeClass('noscroll') if @noscroll
    super()

  render: (@append_to) ->
    App.current.push(this)
    _el = $("[data-view=#{@page}]") if @page?
    @setElement(_el) if _el?.length
    @listenToOnce(@model, 'destroy', @remove) if @model?
    return @append() if @in_view() and @$el?.html()?.length
    json = (@model or @collection)?.toJSON() or {}
    json = {collection: json} if _(json).isArray()
    dust.render "templates/#{@template or @id}", json, (err, out) =>
      @setElement(out).append()
    return this

class App.OverlayView extends App.View
  className:  'overlay'
  ov_class:   'ov_content'

  overlay_events:
    'click':                        'remove'
    'click .close, [data-close]':   'remove'
    'click .ov_content':            'stop_propagation'
    'click a[href], a[data-modal]': 'continue_propagation'

  continue_propagation: (e) ->
    e.should_continue = true

  render: ->
    @noscroll = true
    App.current.push(this)
    body  = $('<div />', class: 'ov_body').appendTo @$el
    inner = $('<div />', class: 'ov_inner').appendTo body
    @$ov  = $('<div />', class: @ov_class, id: @ov_id).appendTo inner
    json  = (@model or @collection)?.toJSON() or {}
    dust.render "templates/#{@template or @ov_id}", json, (err, out) =>
      @$ov.html(out)
      @$el.appendTo $('body').addClass('noscroll')
      @trigger('view:render')
    return this
