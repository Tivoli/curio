class App.views.RegisterModal extends App.View
  @mixins('Overlay')

  ov_id:    'register_modal'
  template: 'application/modals/register'

  dom_events:
    'submit form': 'register'

  register: (e) ->
    e.preventDefault()
    el    = $(e.currentTarget).validate()
    return if el.data('errors') > 0
    data  = el.serializeObject()
    new App.models.User(data).save().done (user) =>
      App.user.set(user)
      @remove()
