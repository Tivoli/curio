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

  view_data: ->
    return {} unless @model? or @collection?
    @listenToOnce(@model, 'destroy', @remove) if @model?
    data = (@model or @collection)?.toJSON()
    data = {collection: data} if _(data).isArray()
    return data

  remove: ->
    @trigger('view:remove')
    @stopListening()
    App.remove_view(this)
    $('body').removeClass('noscroll') if @noscroll
    super()

  render: ->
    App.current.push(this)
    if @page
      _el = $("[data-view=#{@page}]")
      return @setElement(_el).append() if _el.length
    return @render_template() unless @model? or @collection?
    (@model or @collection).fetch({data: @fetch_options}).done =>
      @render_template()
    return this
