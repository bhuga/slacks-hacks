
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

sentByMeMessages = (selector) ->
  selector = '.message_sender[data-member-id=' + TS.boot_data.user_id + ']'
  messages = $(selector).closest('ts-message')
  messages.each (_, el) ->
    $(el).addClass 'sent_by_me'

TS.groups.message_received_sig.add(botAdder)
TS.channels.message_received_sig.add(botAdder)
TS.channels.switched_sig.add botifyMessages
TS.groups.switched_sig.add botifyMessages

TS.channels.switched_sig.add sentByMeMessages
TS.groups.switched_sig.add sentByMeMessages
TS.groups.message_received_sig.add(sentByMeMessages)
TS.channels.message_received_sig.add(sentByMeMessages)
