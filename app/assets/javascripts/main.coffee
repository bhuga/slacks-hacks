
console.log "Hello from slacks hacks!"

botify = (selector) ->
  selector.each (_, el) ->
    if $(el).find('.bot_label').length != 0
      $(el).addClass 'bot'

botAdder = (arg1, msg) ->
  botify($('[data-ts="' + msg.ts + '"]'))

botifyMessages = =>
  botify($('.message'))

# Botify the currently-viewed channel
botifyMessages()

# Attach .sent_by_me to messages sent by the current user
meAdder = (selector) ->
  selector.each (_, el) ->
    $(el).addClass 'sent_by_me'

sentByMeMessages = ->
  selector = '.message_sender[data-member-id=' + TS.boot_data.user_id + ']'
  messages = $(selector).closest('ts-message')
  messages.each (_, el) ->
    $(el).addClass 'sent_by_me'

multiline = (selection) ->
  selection.html().match(/<br>/)?

addMultilineToMessages = ->
  $('.attachment_contents').each (_, el) ->
    selection = $(el)
    if selection.html().match(/<br>/)
      selection.closest('content').addClass 'multiline_attachment'

redraw = ->
  botifyMessages()
  sentByMeMessages()
  addMultilineToMessages()

TS.groups.message_received_sig.add redraw
TS.channels.message_received_sig.add redraw
TS.channels.switched_sig.add redraw
TS.groups.switched_sig.add redraw
