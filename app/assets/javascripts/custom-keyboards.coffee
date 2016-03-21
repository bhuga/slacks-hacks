# A rough implementation of 'custom keyboards', similar to
# https://core.telegram.org/bots#keyboards

fillMessageBar = (text) ->
  $("#message-input").val(text)
  $("#message-input").focus()

window.repaintKeyboards = ->
  label_regex = /label:([^:/]+)(?::([^:/]+))?/
  buttons = $('a').filter ->
    @href.indexOf("https://a.button") == 0

  buttons.each (_, el) ->
    fields = el.href.split("/", 5)
    label = decodeURIComponent(fields[3])
    command = decodeURIComponent(fields[4])
    button_class = ""
    if match = label.match(label_regex)
      window.ev = match
      console.log match
      color = match[2]
      button_class = "icon"
      label = "<i class=\"#{color} ts_icon ts_icon_#{match[1]}\"></i>"
    button = $("<button class='inserted_button #{button_class}'>#{label}</button>")
    button.click ->
      fillMessageBar(command)
    $(el).replaceWith(button)

slackReadyFunction(window.repaintKeyboards)
