class App.views.User extends App.View
  @include('Overlay', 'ModelEdit')
  id:       'user_overlay'
  template: 'users/show'

  initialize: (opts={}) ->
    @listenToOnce @model, 'sync', @remove

  dom_events:
    'change [name=is_admin]': 'update_admin'

  update_admin: (e) ->
    el = $(e.currentTarget)
    method = if el.is(':checked') then 'post' else 'delete'
    @model.ajax('/roles', method, {role: 'admin'}).done (data) =>
      @model.set(data)
