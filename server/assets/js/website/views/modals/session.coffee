class App.views.SessionModal extends App.View
  @include('Modal')
  ov_id:    'session_modal'
  template: 'modals/session'

  dom_events:
    'submit form': 'sign_in'

  sign_in: (e) ->
    e.preventDefault()
    el    = $(e.currentTarget).validate()
    return if el.data('errors') > 0
    data  = el.serializeJSON()
    App.Api.post('/sessions', data).done (user) =>
      App.user.set(user)
      @remove()
