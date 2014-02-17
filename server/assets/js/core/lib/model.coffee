class App.Model extends Backbone.Model

  select: ->
    @collection.select(this)

  previous: ->
    idx = @collection.indexOf(this)
    return @collection.last() if idx is 0
    @collection.at(idx - 1)

  next: ->
    idx = @collection.indexOf(this) + 1
    return @collection.first() if idx is @collection.length
    @collection.at(idx)

  ajax: (path, method='get', data) ->
    path    = path.replace(/^\//, '')
    App.Api[method.toLowerCase()]("#{@url()}/#{path}", data)
