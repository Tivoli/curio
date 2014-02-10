class App.views.Posts extends App.View
  @include('Page')
  page:     'Posts'
  template: 'posts/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Posts
