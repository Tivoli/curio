class App.views.Pages extends App.View
  @include('Page', 'ModelList')
  page:     'Pages'
  template: 'pages/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Pages
    @listenTo this, 'view:create', @on_select

  on_select: (model) ->
    new App.views.Page(model: model).render()

  on_add: (model) ->
    view = new App.views.PageItem(model: model)
    view.prepend_to = @$('.model-list ul')
    view.render()
