class App.views.Posts extends App.View
  @include('Page')
  template: 'cms/posts/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Posts
    @listenTo @collection, 'add', @on_add

  on_add: (m) ->
    console.log m.toJSON()
