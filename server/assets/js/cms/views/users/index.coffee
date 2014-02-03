class App.views.Users extends App.View
  @mixins('Page')
  template: 'cms/users/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Users
    @listenTo @collection, 'add', @on_add

  on_add: (m) ->
    console.log m.toJSON()
