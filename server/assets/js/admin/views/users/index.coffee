class App.views.Users extends App.View
  @include('Page', 'ModelList')
  page: 'Users'
  template: 'users/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Users

  on_select: (model) ->
    new App.views.User(model: model).render()

  on_add: (model) ->
    view = new App.views.UserItem(model: model)
    view.prepend_to = @$('.model-list ul')
    view.render()
