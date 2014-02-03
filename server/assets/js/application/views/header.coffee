class App.views.Header extends App.View

  initialize: (opts={}) ->
    @listenTo @model, 'change', @change

  change: (m) ->
    dust.render 'application/header/user', @model.toJSON(), (err, out) =>
      @$('.header-user').html(out)
