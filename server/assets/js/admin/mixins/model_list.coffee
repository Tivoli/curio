class App.mixins.ModelList

  model_list_events:
    'input [type=search]': 'filter'

  filter: (e) ->
    el = $(e.currentTarget)
    clearTimeout(@timer)
    @timer = setTimeout =>
      return @collection.fetch() unless el.val().length
      App.Api.get('/search', {q: el.val(), core: el.data('core')})
        .done (data) => @collection.set(data)
    , 300

  toggle_search: (e) ->
    @$('form[action="/search"]').toggleClass('open')

  create_model: (e) ->
    model = new @collection.model
    @trigger('view:create', model)
    @listenToOnce(model, 'sync', -> @collection.add(model))
