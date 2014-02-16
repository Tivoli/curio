class App.views.Post extends App.View
  @include('Overlay', 'ModelEdit')
  id:       'post_overlay'
  template: 'posts/show'

  initialize: (opts={}) ->
    @listenToOnce @model, 'sync', @remove
