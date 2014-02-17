class App.mixins.ListItem

  list_item_events:
    'click a': 'select'

  select: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.select()
