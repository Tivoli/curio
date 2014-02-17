class App.models.Page extends App.Model
  urlRoot: '/pages'

  title:    -> @get('title')
  path:     -> @get('path')
  context:  -> @get('context')
