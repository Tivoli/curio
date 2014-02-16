class App.views.Users extends App.View
  @include('Page', 'ModelList')
  page: 'Users'
  template: 'users/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Users
