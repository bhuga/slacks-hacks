css = document.createElement 'link'
css.setAttribute 'href', 'https://github.dev/assets/application.css'
css.setAttribute 'type', 'text/css'
css.setAttribute 'rel', 'stylesheet'
document.head.appendChild css

console.log "Hello from slacks hacks!"

foobarize = (selector) ->
  selector.addClass('foobar')

fooBarAdder = (arg1, msg) ->
  foobarize($('data-ts="' + msg.ts + '"]'))

TS.groups.message_received_sig.add(fooBarAdder)
TS.channels.message_received_sig.add(fooBarAdder)

foobarizeMessages = =>
  foobarize($('.message'))

TS.channels.switched_sig.add foobarizeMessages
TS.groups.switched_sig.add foobarizeMessages

botify = (selector) ->
  selector.each (_, el) ->
    if $(el).find('.bot_label').length != 0
      $(el).addClass 'bot'

botAdder = (arg1, msg) ->
  botify($('data-ts="' + msg.ts + '"]'))

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
#replaceDispatch(eventManager)
if false
  for key in Object.keys(TS)
    for subkey in Object.keys(TS[key])
      if subkey.match(/_sig$/)
        ( ->
          console.log "breaking dispatch on #{key}.#{subkey}"
          foo = key
          bar = subkey
          unless "#{key}.#{subkey}" in whitelist
            TS[foo][bar].dispatch = =>
              console.log "calling #{foo}.#{bar}")()
