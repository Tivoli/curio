class App.views.Pages extends App.View
  @include('Page', 'ModelList')
  page:     'Pages'
  template: 'pages/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Pages
    @listenTo this, 'view:create', @edit_page

  edit_page: (model) ->
    new App.views.Page(model: model).render()

  on_add: (model) ->
    dust.render 'templates/pages/list_item', model.toJSON(), (err, out) =>
      @$('.model-list ul').prepend(out)
