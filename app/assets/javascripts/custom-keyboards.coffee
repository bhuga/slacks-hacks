# A rough implementation of 'custom keyboards', similar to
# https://core.telegram.org/bots#keyboards

fillMessageBar = (text) ->
  $("#message-input").val(text)
  $("#message-input").focus()

window.repaintKeyboards = ->
  console.log "checking keyboards"
  buttons = $('a').filter ->
    @href.indexOf("https://a.button") == 0

  buttons.each (_, el) ->
    fields = el.href.split("/", 5)
    console.log fields
    label = decodeURI(fields[3])
    command = decodeURI(fields[4])
    button = $("<button class='inserted_button'>#{label}</button>")
    button.click ->
      fillMessageBar(command)
    $(el).replaceWith(button)

slackReadyFunction(window.repaintKeyboards)
