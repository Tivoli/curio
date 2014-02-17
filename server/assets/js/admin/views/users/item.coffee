class App.views.UserItem extends App.View
  @include('Module', 'ListItem')
  template: 'users/list_item'

  initialize: (opts={}) ->
    @listenTo @model, 'change', @on_change

  on_change: (m) ->
    text = if @model.is_admin() then 'Admin' else ''
    @$('.admin').html(text)
    @$('.username').html("#{@model.username()} (#{@model.email()})")
