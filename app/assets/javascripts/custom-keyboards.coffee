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

  images = $('a').filter ->
    @href.indexOf("https://a.img.button") == 0

  images.each (_, el) ->
    fields = el.href.split("/", 5)
    image_url = decodeURIComponent(fields[3])
    command = decodeURIComponent(fields[4])
    button = $("<button class='inserted_button image'><img src=\"#{image_url}\"></button>")
    button.click ->
      fillMessageBar(command)
    $(el).replaceWith(button)

  selects = $('a').filter ->
    @href.indexOf("https://a.select") == 0

  selects.each (_, el) ->
    fields = el.href.split("/").slice(3)
    options = fields.map (field, i) ->
      field = decodeURIComponent(field)
      [title, command] = field.split(":")
      selected = if i == 0 then "selected" else ""
      "<option value=\"#{command}\" #{selected}>#{title}</option>"
    select = $("<select class='inserted_select'>#{options}</select>")
    select.change ->
      fillMessageBar(select.val())
    $(el).replaceWith(select)



slackReadyFunction(window.repaintKeyboards)
