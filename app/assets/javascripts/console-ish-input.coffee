input = TS.client.ui.$msg_input

# by default slack won't go to previous commands with 'up', just to the front
# of the line. Fix that if there's no newlines in the message.
input.bind "keydown", (e) ->
  return if input.val().indexOf("\n") != -1

  if (e.which == TS.utility.keymap.up && input.getCursorPosition() >= 1 && !e.movedHistory)
    TS.chat_history.onArrowKey(e, input)
    input.setCursorPosition(input.val().length)
    e.preventDefault()
  else if (e.which == TS.utility.keymap.down && input.getCursorPosition() < input.val().length)
    TS.chat_history.onArrowKey(e, input)
    input.setCursorPosition(input.val().length)
    e.preventDefault()

input.bind "keydown", (e) ->
  # ctrl-w
  return unless e.ctrlKey == true and e.keyCode == 87

  currentIndex = input.getCursorPosition()
  currentValue = input.val()
  beforeCurrent = currentValue.substring(0, currentIndex)

  previousWhitespaceIndex = beforeCurrent.lastIndexOf(" ")
  previousWhitespaceIndex = 0 if previousWhitespaceIndex == -1
  valueWithWordRemoved = currentValue.slice(0, previousWhitespaceIndex) + currentValue.slice(currentIndex)
  TS.utility.populateInput(input, valueWithWordRemoved)
  input.setCursorPosition(previousWhitespaceIndex)

input.bind "keydown", (e) ->
  # ctrl-k
  return unless e.ctrlKey == true and e.keyCode == 75

  currentIndex = input.getCursorPosition()
  currentValue = input.val()
  TS.utility.populateInput(input, currentValue.slice(0, currentIndex))
  input.setCursorPosition(currentIndex)

input.bind "keydown", (e) ->
  # ctrl-u
  return unless e.ctrlKey == true and e.keyCode == 85

  currentIndex = input.getCursorPosition()
  currentValue = input.val()
  TS.utility.populateInput(input, currentValue.slice(currentIndex))
  input.setCursorPosition(0)

# here be dragons: !$
old_submit = TS.view.submit
TS.view.submit = (event) ->
  current = input.val()
  if current.indexOf("!$") != -1
    history = TS.chat_history.initializeChannelHistory(TS.model.active_cid)
    last_message = history.entries[0]
    last_word = last_message.slice(last_message.trim().lastIndexOf(" ") + 1)
    # Prevents expanding `!$`. Should prevent expanding in backticks entirely, maybe?
    replaced = current.replace(/(^|[^`])!\$/g, "$1" + last_word)
    input.val(replaced)
  old_submit(event)
