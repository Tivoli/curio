class App.Collection extends Backbone.Collection

  select: (m) ->
    @trigger('select', m)
