# stolen from http://stackoverflow.com/questions/6029251/jquery-bind-event-listener-before-another
# thanks, internet stranger!
$.fn.preBind = (type, data, fn) ->
  @each ->
    thing = $(@)
    thing.bind(type, data, fn);
    currentBindings = $._data(this, 'events')[type]
    if $.isArray(currentBindings)
      currentBindings.unshift(currentBindings.pop())
    return @

# Slack uses a giant function, `doLinkThings`, over the entire message. I'm
# not sure why yet, performance somehow? If we want to make something happen
# instead of one of their events, we can't use $(el).bind -- the msg div
# event is attached directly. So we cram our event to the front of the list.
$(TS.client.ui.$msgs_div).preBind 'click', (event) ->
  # this crazy offset stuff is because we're using a pseudo-element to add the
  # 'X' to click on. These numbers depend on css rules. You might ask,
  # What could go wrong?, and I'd say, Why are you injecting javascript if that
  # worries you?
  return unless $(event.target).hasClass("msg_inline_img_container")

  width = event.target.clientWidth
  inXRange = event.offsetX >= (width - 45) && event.offsetX <= (width - 15)
  inYRange = event.offsetY >= 15 && event.offsetY <= 45
  if inXRange && inYRange
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()
    $(event.target).closest('.msg_inline_img_holder').addClass('hidden')
