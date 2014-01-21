class window.AppRouter extends Backbone.Router

  initialize: (opts={}) ->
    $(document)
      .on('click', '[data-modal]', (e) ->
        e.preventDefault()
        el      = $(e.currentTarget)
        modal   = el.data('modal')
        options = el.data('modal-options')
        new App.views[modal](options).render()
      )
      .on('click', 'a[href]:not([target]):not([data-bypass])', (e) =>
        href = $(e.currentTarget).attr('href')
        return if /^(https?|mailto|javascript|#)/.test(href)
        e.preventDefault()
        @navigate(href.slice(1), trigger: true))

  routes:
    '':               'home'

  route: (route, name, fn) ->
    super route, name, =>
      @trigger 'route:before', route, name
      fn?.apply(this)
