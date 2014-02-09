class App.mixins.Overlay
  className:  'overlay'
  ov_class:   'ov_content'

  overlay_events:
    'click':                        'remove'
    'click .close, [data-close]':   'remove'
    'click .ov_content':            'stop_propagation'
    'click a[href], a[data-modal]': 'continue_propagation'

  render_template: ->
    @noscroll   = true
    @append_to  = $('body').addClass('noscroll')
    body  = $('<div />', class: 'ov_body').appendTo(@$el)
    inner = $('<div />', class: 'ov_inner').appendTo(body)
    @$ov  = $('<div />', class: @ov_class, id: @ov_id).appendTo(inner)
    dust.render @view_template(), @view_data(), (err, out) =>
      @$ov.html(out)
      @trigger('view:render')
    return this
