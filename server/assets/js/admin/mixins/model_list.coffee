class App.mixins.ModelList

  toggle_search: (e) ->
    @$('form[action="/search"]').toggleClass('open')

  create_model: (e) ->
    model = new @collection.model
    @trigger('view:create', model)
    @listenToOnce(model, 'sync', -> @collection.add(model))
