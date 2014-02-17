class App.views.PageItem extends App.View
  @include('Module', 'ListItem')
  template: 'pages/list_item'

  initialize: (opts={}) ->
    @listenTo @model, 'sync', @on_sync

  on_sync: (m) ->
    @$('.title').html(@model.title())
    @$('.path').html(@model.path())
