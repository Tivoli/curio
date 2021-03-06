class App.mixins.Module

  render_template: ->
    return @trigger('view:render') if @$el.html().length
    dust.render @view_template(), @view_data(), (err, out) =>
      @$el.html(out)
      @trigger('view:render')
    return this
