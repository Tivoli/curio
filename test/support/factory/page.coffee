idx = 1

module.exports = (page={}) ->
  defaults =
    path: "path-#{idx++}"
    context: """
      #Sit ea adipisci.
      Sit accusantium quia totam unde?

      Elit accusantium perferendis deserunt tempore.
      * Consectetur.
      * Consectetur.
    """
  return _(page).defaults(defaults)
