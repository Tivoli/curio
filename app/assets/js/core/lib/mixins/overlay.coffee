class App.mixins.Overlay
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
