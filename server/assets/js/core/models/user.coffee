class App.models.User extends App.Model
  urlRoot: '/users'

  name:     -> @get('name')
  username: -> @get('username')
  email:    -> @get('email')
  is_admin: -> @get('is_admin')
