class App.views.Page extends App.View
  @include('Overlay', 'ModelEdit')
  id:       'page_overlay'
  template: 'pages/show'

  initialize: (opts={}) ->
    @listenToOnce @model, 'sync', @remove
