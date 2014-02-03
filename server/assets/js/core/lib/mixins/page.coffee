class App.mixins.Page

  append: ->
    @$el.appendTo($('[role=main]')) unless @in_view()
    for child in @$('[data-view]')
      el = $(child)
      new App.views[el.data('view')](el: el).render()
    @trigger('view:render')

  render_template: ->
    dust.render @template, @view_data(), (err, out) =>
      @setElement(out).append()
    return this
