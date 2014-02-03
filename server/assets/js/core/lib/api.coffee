App.Api =
  request: (method, url, data) ->
    url   = url.replace(/^\//, '')
    data  = JSON.stringify(data) unless method is 'GET'
    $.ajax
      url: "/#{url}"
      type: method
      data: data
      dataType: 'json'
      contentType: 'application/json'

  get:    (url, data) -> App.Api.request('GET', url, data)
  post:   (url, data) -> App.Api.request('POST', url, data)
  put:    (url, data) -> App.Api.request('PUT', url, data)
  delete: (url, data) -> App.Api.request('DELETE', url, data)
