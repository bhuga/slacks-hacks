# A rough implementation of 'custom keyboards', similar to
# https://core.telegram.org/bots#keyboards

fillMessageBar = (text) ->
  $("#message-input").val(text)
  $("#message-input").focus()

window.repaintKeyboards = ->
  buttons = $('a').filter ->
    @href.indexOf("https://a.button") == 0

  buttons.each (_, el) ->
    fields = el.href.split("/", 5)
    label = decodeURIComponent(fields[3])
    command = decodeURIComponent(fields[4])
    button = $("<button class='inserted_button'>#{label}</button>")
    button.click ->
      fillMessageBar(command)
    $(el).replaceWith(button)

slackReadyFunction(window.repaintKeyboards)
