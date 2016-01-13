# A rough implementation of 'custom keyboards', similar to
# https://core.telegram.org/bots#keyboards

parseMaybeJson = (text) ->
  try
    JSON.parse(text)
  catch
    return null

fillMessageBar = (text) ->
  $("#message-input").val(text)
  $("#message-input").focus()

# A button looks like <|button|text|.message to send>
buttonRegex = /:\|button\|([^|]+)\|([^>]+):/g

window.repaintKeyboards = ->
  $('ts-message').each (_, el) ->
    matched = false
    messageBody = $(el).find('.message_body')
    html = messageBody.html()
    matchCommands = undefined

    while match = buttonRegex.exec(html)
      matchCommands ||= {}
      matched = true
      buttonText = "<button class='inserted_button' id='match-#{buttonRegex.lastIndex}'>#{match[1]}</button>"
      html = html.replace(match[0], buttonText)
      matchCommands[buttonRegex.lastIndex] = fillMessageBar.bind(@, match[2])

    if matched
      messageBody.html(html)
      for key in Object.keys(matchCommands)
        messageBody.find("#match-#{key}").click(matchCommands[key])

slackReadyFunction(window.repaintKeyboards)
