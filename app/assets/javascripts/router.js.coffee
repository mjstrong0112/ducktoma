@Router = {}

UTIL =
  exec: (controller, action) ->
    ns = Router
    action = (if (action is `undefined`) then "init" else action)
    ns[controller][action]()  if controller isnt "" and ns[controller] and typeof ns[controller][action] is "function"

  init: ->
    body = document.body
    controller = $('body').data "controller"
    action = $('body').data "action"
    UTIL.exec "common"
    UTIL.exec controller
    UTIL.exec controller, action

$ -> UTIL.init()