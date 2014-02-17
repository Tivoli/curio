class App.mixins.ListItem

  dom_events:
    'click a': 'select'

  select: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.select()
