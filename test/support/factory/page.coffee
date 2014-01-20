idx = 0

module.exports = (page={}) ->
  idx++
  defaults =
    path: "path-#{idx}"
    title: "Pages #{idx}"
    context: """
      #Sit ea adipisci.
      Sit accusantium quia totam unde?

      Elit accusantium perferendis deserunt tempore.
      * Consectetur.
      * Consectetur.
    """
  return _(page).defaults(defaults)
