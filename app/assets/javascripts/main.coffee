css = document.createElement 'link'
css.setAttribute 'href', 'https://github.dev/assets/application.css'
css.setAttribute 'type', 'text/css'
css.setAttribute 'rel', 'stylesheet'
document.head.appendChild css

console.log "Hello from slacks hacks!"

fooBarAdder = (arg1, msg) ->
  $('[data-ts="' + msg.ts + '"]').addClass('foobar').css('background-color','#A9F5F2')

TS.groups.message_received_sig.add(fooBarAdder)
