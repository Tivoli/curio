class App.models.Post extends App.Model
  urlRoot: '/posts'

  title:      -> @get('title')
  slug:       -> @get('slug')
  context:    -> @get('context')
  author:     -> @get('author')
  created_at: -> @get('created_at')
