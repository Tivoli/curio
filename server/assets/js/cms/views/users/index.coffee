class App.views.Users extends App.View
  @include('Page')
  page: 'Users'
  template: 'users/index'

  initialize: (opts={}) ->
    @collection = new App.collections.Users
