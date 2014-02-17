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
    dust.render 'templates/posts/list_item', model.toJSON(), (err, out) =>
      @$('.model-list ul').prepend(out)
