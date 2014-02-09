class App.mixins.Page

  append: ->
    @$el.appendTo($('[role=main]')) unless @in_view()
    for child in @$('[data-view]')
      el    = $(child)
      model = @collection?.get(el.data('id')) if el.data('id')
      new App.views[el.data('view')](el: el, model: model).render()
    @trigger('view:render')

  render_template: ->
    _el = $("[data-view=#{@page}]") if @page?
    return @setElement(_el).append() if _el?.length
    dust.render @view_template(), @view_data(), (err, out) =>
      @setElement(out).append()
    return this
