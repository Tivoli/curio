class App.mixins.Facebook

  signup: (e) ->
    FB.login (res) =>
      return unless res.authResponse?
      body =
        uid: res.authResponse.userID
        token: res.authResponse.accessToken
      App.Api.post('/oauth/facebook', body).done (user) =>
        App.user.set(user)
        @remove()
    , {scope: 'email,publish_stream'}
