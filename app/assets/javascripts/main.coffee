
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

addMultilineToMessages = ->
  $('.attachment_contents').each (_, el) ->
    selection = $(el)
    if selection.html().match(/<br>/)
      selection.closest('.content').first().addClass('multiline_attachment')

removeTinyImageGarbage = ->
  $('.file_preview_preserve_aspect_ratio').each (_, el) ->
    $(el).css('width','').css('height','')

slackBuildImgDiv = TS.templates.builders.buildInlineImgDiv
TS.templates.builders.buildInlineImgDiv = (args...) ->
  result = slackBuildImgDiv(args...)
  width = result.match(/data-width="(\d+)"/)[1]
  max_width = TS.client.ui.$msgs_div.width() - 156

  height = result.match(/data-height="(\d+)"/)[1]
  max_height = if max_width >= width
                height
              else
                (max_width / width) * height

  result = result.replace(/<div class="file_preview_preserve_aspect_ratio" style="width: \d+px; height: \d+px;">/,
                          "<div class=\"file_preview_preserve_aspect_ratio\" style=\"width: #{max_width}px; height: #{max_height}px;\">")
  result


redraw = ->
  botifyMessages()
  sentByMeMessages()
  addMultilineToMessages()
  removeTinyImageGarbage()

slackReadyFunction(redraw)
