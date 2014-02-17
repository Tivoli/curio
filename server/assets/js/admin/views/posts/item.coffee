class App.views.PostItem extends App.View
  @include('Module', 'ListItem')

  initialize: (opts={}) ->
    @listenTo @model, 'sync', @on_sync

  on_sync: (m) ->
    @$('.title').html(@model.title())
