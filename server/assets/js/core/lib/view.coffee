class App.View extends Backbone.View

  @include: (mixins...) ->
    for mixin in mixins
      for own key, value of App.mixins[mixin]::
        this::[key] = value

  view_events:
    'click a[data-action]': 'call_action'

  events: ->
    events = {}
    _(events).extend(v) for k, v of this when /[\w]+_events$/.test(k)
    return events

  call_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    action = $(e.currentTarget).data('action')
    @[action](e)

  stop_propagation: (e) ->
    e.stopPropagation() unless e.should_continue

  continue_propagation: (e) ->
    e.should_continue = true

  in_view: ->
    $.contains(document.documentElement, @$el[0])

  view_data: ->
    return {} unless @model? or @collection?
    @listenToOnce(@model, 'destroy', @remove) if @model?
    data = (@model or @collection)?.toJSON()
    data = {collection: data} if _(data).isArray()
    return data

  view_template: ->
    return "templates/#{@template}"

  prerender: ->
    new Promise (resolve, reject) =>
      return resolve() unless @model?.id? or @collection?
      return resolve(@model.toJSON()) if @model?.collection?
      (@model or @collection).fetch({data: @fetch_options})
        .done(resolve)
        .fail(reject)

  post_render: ->
    FB?.XFBML.parse(@$el[0])
    twttr?.widgets.load(@$el[0])
    @listenTo(@collection, 'add', @on_add) if @collection? and @on_add?
    @listenTo(@collection, 'select', @on_select) if @collection? and @on_select?
    @$el.appendTo(@append_to) if @append_to?
    @$el.prependTo(@prepend_to) if @prepend_to?
    @trigger('view:append')
    return this

  render: (@append_to) ->
    App.current.push(this)
    @prerender().then (data) =>
      @listenToOnce(this, 'view:render', @post_render)
      @render_template()
    return this

  remove: ->
    @trigger('view:remove')
    @stopListening()
    App.remove_view(this)
    $('body').removeClass('noscroll') if @noscroll
    super()
