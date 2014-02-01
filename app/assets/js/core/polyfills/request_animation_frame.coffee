do ->
  for vendor in ['ms', 'moz', 'webkit', 'o']
    break if window.requestAnimationFrame
    window.requestAnimationFrame  = window["#{vendor}RequestAnimationFrame"]
    window.cancelAnimationFrame   = window["#{vendor}CancelAnimationFrame"] or window["#{vendor}CancelRequestAnimationFrame"]

  lastTime = 0
  window.requestAnimationFrame ?= (callback, element) ->
    currTime    = Date.now()
    timeToCall  = Math.max(0, 16 - (currTime - lastTime))
    window.setTimeout (-> callback(currTime + timeToCall)), timeToCall

  window.cancelAnimationFrame ?= (id) -> clearTimeout(id)
