idx = 0

module.exports = (post={}) ->
  idx++
  defaults =
    title: "Post Title #{idx}"
    context: """
      Sit culpa cupiditate ratione laborum soluta aspernatur?
      Excepturi a quibusdam cum corporis accusamus minus.
      Asperiores pariatur libero blanditiis adipisci dignissimos
      modi nesciunt exercitationem ullam beatae. Odio amet facere
      aperiam quam?'
    """
