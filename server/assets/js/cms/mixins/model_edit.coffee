class App.mixins.ModelEdit

  model_edit_events:
    'submit form':              'save'
    'input .markdown textarea': 'markdown'
    'click .markdown i':        'cheatsheet'
    'change input[type=file]':  'upload'

  markdown: (e) ->
    el      = $(e.currentTarget)
    return unless el.data('preview')?
    @$(el.data('preview')).html(marked(el.val()))

  cheatsheet: (e) ->

  s3_form_data: (data, file, key) ->
    fd = new FormData
    fd.append('key', key)
    fd.append('AWSAccessKeyId', data.access_key)
    fd.append('acl', 'public-read')
    fd.append('policy', data.policy)
    fd.append('signature', data.signature)
    fd.append('Content-Type', file.type)
    fd.append('success_action_status', '201')
    fd.append('file', file)
    return fd

  s3_upload: (form, bucket) ->
    new Promise (resolve, reject) ->
      req = new XMLHttpRequest
      req.open('POST', "//#{bucket}.s3.amazonaws.com", true)
      req.onload = ->
        return reject(Error(req.statusText)) unless req.status is 201
        $xml    = $($.parseXML(@response or @responseText))
        s3_url  = decodeURIComponent($xml.find('Location').text())
        path    = $('<a />', {href: s3_url})[0].pathname
        upload =
          s3_url: s3_url
          path:   "/uploads#{path}"
          ts:     Math.floor(Date.now() / 1000)
        resolve(upload)
      req.onerror = ->
        reject(Error('Network Error'))
      req.send(form)

  upload: (e) ->
    return unless window.FormData?
    e.stopPropagation()
    el = $(e.currentTarget)
    App.Api.get('/uploads/cors').done (data) =>
      file  = (e.target.files or e.dataTransfer.files)[0]
      key   = el.data('key').replace('$id', data.short_id)
      fd    = @s3_form_data(data, file, key)
      @s3_upload(fd, data.bucket)
        .then (upload) => @trigger('view:upload', upload)

  save: (e) ->
    e.preventDefault()
    el = $(e.currentTarget).validate()
    return if el.data('errors') > 0
    @model.save(el.serializeJSON(), {wait: true})
