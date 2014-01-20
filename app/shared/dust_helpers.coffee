marked  = if exports? then require('marked') else window.marked
qs      = if exports? then require('querystring').stringify else $.param

dust.helpers.markdown = (chunk, context, bodies, params) ->
  if bodies.block
    return chunk.capture(bodies.block, context, (string, chunk) ->
      chunk.end marked(string)
    )
  return chunk
