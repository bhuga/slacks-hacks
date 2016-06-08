
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
  $('.attachment_group').each (_, el) ->
    selection = $(el)
    if selection.html().match(/<br>/)
      selection.find('.msg_inline_attachment_row').addClass('multiline_attachment')

slackBuildImgDiv = TS.templates.builders.buildInlineImgDiv
TS.templates.builders.buildInlineImgDiv = (args...) ->
  result = slackBuildImgDiv(args...)
  width = result.match(/data-width="(\d+)"/)[1]
  height = result.match(/data-height="(\d+)"/)[1]
  result = result.replace(/style="(width|height):\d+px;"/g, "").replace(/style="width:\s*\d+px;\s*height:\s*\d+px;"/g, '')
  src = result.match(/img data-real-src="([^"]+)"/)[1]
  result = result.replace(/<img/, "<img src=\"#{src}\"  ")
  result = result.replace(/<figure/,"<figure style='max-height:#{height}px;' ")
  result = result.replace(' hidden"', "")
  #console.log result
  window.requestAnimationFrame ->
    #console.log "sh in RAF:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  result

slackMetricsMeasure = TS.metrics.measure
TS.metrics.measure = (args...) ->
  if args[0] == "message_render" && args[1] == "start_message_render"
    #console.log "sh after render:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
    TS.client.msg_pane.rebuild_sig?.dispatch()
    $scroller_div.scrollTop($scroller_div[0].scrollTop + 1)
    $div.css("transform", "translateZ(0);")
    #console.log "sh after rebuild sig:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  slackMetricsMeasure(args...)
###
slackScrollInview = TS.client.ui.scrollMsgsSoFirstUnreadMsgIsInView
TS.client.ui.scrollMsgsSoFirstUnreadMsgIsInView = (args...) ->
  console.log "doing this other weird scroll. super weird."
  #slackScrollInview(args...)
###
slackismtb = TS.client.ui.instaScrollMsgsToBottom
TS.client.ui.instaScrollMsgsToBottom = (args...) ->
  #console.log "sh before check inline imgs in instascroll to bottom:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  TS.client.ui.checkInlineImgsAndIframesMain()
  TS.client.msg_pane.rebuild_sig.dispatch()
  $div.css("transform", "translateZ(0);")
  #console.log "sh after check inline imgs in instascroll to bottom:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  slackismtb(args...)
###
slackUEM = TS.client.msg_pane.updateEndMarker
TS.client.msg_pane.updateEndMarker = (args...) ->
  slackUEM(args...)
  console.log "sh in update end marker:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"

slackRBMS = TS.client.msg_pane.rebuildMsgs
TS.client.msg_pane.rebuildMsgs = (args...) ->
  slackRBMS(args...)
  console.log "sh after rbms:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"

slackpomsr = TS.client.msg_pane.padOutMsgsScrollerRAF
TS.client.msg_pane.padOutMsgsScrollerRAF = (args...) ->
  slackpomsr(args...)
  console.log "sh after padoutmsgsscrollerraf (#{TS.shared.getActiveModelOb().name}:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
###

redraw = ->
  botifyMessages()
  sentByMeMessages()
  addMultilineToMessages()

slackchcki = TS.client.ui.checkInlineImgsAndIframesMain
TS.client.ui.checkInlineImgsAndIframesMain = (args...) ->
  #console.log "sh before check inline imgs:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  slackchcki(args...)
  #console.log "sh after check inline imgs:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"
  TS.client.msg_pane.rebuild_sig.dispatch()
  #console.log "sh after check inline imgs:" + $div[0].scrollHeight + " #{$scroller_div[0].scrollHeight}"

slackReadyFunction(redraw)
TS.pri = "888"
window.$div = TS.client.ui.$msgs_div
window.$scroller_div = TS.client.ui.$msgs_scroller_div
