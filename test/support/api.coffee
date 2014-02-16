module.exports =
  request: (method, uri, args...) ->
    cookie        = _(args).find((arg) -> _(arg).isString())
    data          = _(args).find((arg) -> typeof arg is 'object')
    fn            = _(args).find((arg) -> _(arg).isFunction())
    uri           = if /^https?:/.test(uri) then uri else "http://localhost#{uri}"
    jar           = request.jar()
    jar.setCookie(cookie, 'http://localhost', {}, -> ) if cookie?
    opts          = { uri: uri, method: method, jar: jar }
    opts.headers  = { accept: 'application/json;q=0.9,*/*;q=0.8;' }
    opts[(if method is 'GET' then 'qs' else 'json')] = data if data?
    opts.json ?= {} unless method is 'GET'
    request(opts, fn)

  get:    (path, rest...) -> @request.apply(this, ['GET', path].concat(rest))
  post:   (path, rest...) -> @request.apply(this, ['POST', path].concat(rest))
  put:    (path, rest...) -> @request.apply(this, ['PUT', path].concat(rest))
  delete: (path, rest...) -> @request.apply(this, ['DELETE', path].concat(rest))
