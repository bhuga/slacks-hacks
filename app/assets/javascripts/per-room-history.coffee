existingMessageHistory = localStorage.getItem("per_room_history")
if existingMessageHistory?
  try
    history = JSON.parse(existingMessageHistory)
    TS.model.per_room_input_history = history
  catch e
    console.log "Failed to parse existing history. Moving on with life."

TS.chat_history.initializeChannelHistory = (cid) ->
  TS.model.per_room_input_history ||= {}
  history = TS.model.per_room_input_history[TS.model.active_cid]
  if !history?
    history = {}
    history.index = -1
    history.entries = []
    TS.model.per_room_input_history[TS.model.active_cid] = history

  return history

TS.chat_history.add = (txt) ->
  unless TS.model.prefs?.arrow_history
    return
  if txt is ""
    return

  history = TS.chat_history.initializeChannelHistory(TS.model.active_cid)

  entries = history.entries

  index = entries.indexOf(txt)
  if index != -1
    entries.splice(index, 1)
  entries.unshift(txt)
  entries.splice(30)
  localStorage.setItem("per_room_history", JSON.stringify(TS.model.per_room_input_history))

TS.chat_history.resetPosition = (why) ->
  history = TS.chat_history.initializeChannelHistory(TS.model.active_cid)
  history.index = -1

TS.chat_history.onArrowKey = (e, input) ->
  unless TS.model.prefs?.arrow_history
    return
  history = TS.chat_history.initializeChannelHistory(TS.model.active_cid)
  return unless history.entries.length

  txt = input.val()
  hist_text = ""
  if history.index < 0
    history.current = txt

  if e.which == TS.utility.keymap.up
    history.index += 1
    if history.index >= history.entries.length
      history.index = history.entries.length - 1
      return
  else if e.which == TS.utility.keymap.down
    history.index -= 1
    if history.index < 0
      history.index = -1
      hist_text = history.current
  else
    return

  e.movedHistory = true
  hist_text ||= history.entries[history.index]
  e.preventDefault()
  TS.utility.populateInput(TS.client.ui.$msg_input, hist_text)
  input.setCursorPosition(input.val().length)
