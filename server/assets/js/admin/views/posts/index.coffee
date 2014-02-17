class App.views.Posts extends App.View
  @include('Page', 'ModelList')
  page:     'Posts'
  template: 'posts/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Posts
    @listenTo this, 'view:create', @on_select

  on_select: (model) ->
    new App.views.Post(model: model).render()

  on_add: (model) ->
    view = new App.views.PostItem(model: model)
    view.prepend_to = @$('.model-list ul')
    view.render()
