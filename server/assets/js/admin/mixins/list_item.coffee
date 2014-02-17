class App.mixins.ListItem

  list_item_events:
    'click a': 'select'

  select: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.select()

  render_template: ->
    return @trigger('view:render') if @$el.html().length
    dust.render @view_template(), @view_data(), (err, out) =>
      @setElement(out)
      @trigger('view:render')
    return this
