class App.views.SiteConfig extends App.View
  @include('Module', 'ModelEdit')
  template: 'settings/site_config'

  initialize: (opts={}) ->
    @model = new App.models.SiteConfig(id: 'website')
