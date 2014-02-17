class App.mixins.Overlay
  className:  'overlay'

  overlay_events:
    'click .close, [data-close]': 'close'

  close: (e) ->
    @$el.removeClass('open')
    @$el.one 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', =>
      @remove()

  on_append: ->
    @$el.offset()
    @$el.addClass('open')

  render_template: ->
    @noscroll   = true
    @prepend_to  = $('body').addClass('noscroll')
    dust.render @view_template(), @view_data(), (err, out) =>
      @$el.html(out)
      @listenToOnce(this, 'view:append', @on_append)
      @trigger('view:render')
    return this
