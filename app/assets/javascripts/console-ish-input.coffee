input = TS.client.ui.$msg_input

# by default slack won't go to previous commands with 'up', just to the front
# of the line. Fix that if there's no newlines in the message.
input.bind "keydown", (e) ->
  return if input.val().indexOf("\n") != -1

  if (e.which == TS.utility.keymap.up && input.getCursorPosition() >= 1)
    TS.chat_history.onArrowKey(e, input)
    input.setCursorPosition(input.val().length)
    e.preventDefault()
  else if (e.which == TS.utility.keymap.down && input.getCursorPosition() < input.val().length)
    TS.chat_history.onArrowKey(e, input)
    input.setCursorPosition(input.val().length)
    e.preventDefault()
