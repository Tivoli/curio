class App.View extends Backbone.View

  @mixins: (mixins...) ->
    for mixin in mixins
      continue unless App.mixins[mixin]::?
      this::[key] = value for key, value of App.mixins[mixin]::

  events: ->
    events = {}
    _(events).extend(v) for k,v of this when /[\w]+_events$/.test(k)
    return events

  action_events:
    'submit [data-action=subscribe]': 'form_subscribe'

  stop_propagation: (e) ->
    e.stopPropagation() unless e.should_continue

  in_view: ->
    $.contains(document.documentElement, @$el[0])

  append: ->
    @$el.appendTo(@append_to or $('[role=main]')) unless @in_view()
    for child in @$('[data-view]')
      el = $(child)
      new App.views[el.data('view')](el: el).render()
    @trigger('view:render')

  remove: ->
    @trigger('view:remove')
    @stopListening()
    App.remove_view(this)
    $('body').removeClass('noscroll') if @noscroll
    super()

  render: (@append_to) ->
    App.current.push(this)
    _el = $("[data-view=#{@page}]") if @page?
    @setElement(_el) if _el?.length
    @listenToOnce(@model, 'destroy', @remove) if @model?
    return @append() if @in_view() and @$el?.html()?.length
    json = (@model or @collection)?.toJSON() or {}
    json = {collection: json} if _(json).isArray()
    dust.render "templates/#{@template or @id}", json, (err, out) =>
      @setElement(out).append()
    return this
