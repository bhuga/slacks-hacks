
console.log "Hello from slacks hacks!"

botify = (selector) ->
  selector.each (_, el) ->
    if $(el).find('.bot_label').length != 0
      $(el).addClass 'bot'

botAdder = (arg1, msg) ->
  botify($('[data-ts="' + msg.ts + '"]'))

botifyMessages = =>
  botify($('.message'))

TS.groups.message_received_sig.add(botAdder)
TS.channels.message_received_sig.add(botAdder)
TS.channels.switched_sig.add botifyMessages
TS.groups.switched_sig.add botifyMessages

whitelist = [
  "groups.switched_sig"
  "groups.history_fetched_sig"
]

# Botify the currently-viewed channel
botifyMessages()
