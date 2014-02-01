$.fn.serializeObject = ->
  obj = {}
  arr = @serializeArray()
  $.each arr, ->
    if /(\w+)\[(.*?)\]/.test(@name)
      field = /(\w+)\[(\w+)\]/.exec(@name)
      root  = field[1]
      child = field[2]
      obj[root] ?= {}
      obj[root][child] = @value
    else
      obj[@name] = @value
  return obj
