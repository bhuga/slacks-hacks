$(".msg_inline_img_container").bind 'click', (event) ->
  event.preventDefault()

  # this crazy offset stuff is because we're using a pseudo-element to add the
  # 'X' to click on. These numbers depend on css rules. You might ask,
  # What could go wrong?, and I'd say, Why are you injecting javascript if that
  # worries you?
  width = event.target.clientWidth
  inXRange = event.offsetX >= (width - 45) && event.offsetX <= (width - 15)
  inYRange = event.offsetY >= 15 && event.offsetY <= 45
  if inXRange && inYRange
    event.stopPropagation()
    event.stopImmediatePropagation()
    $(event.target).closest('.msg_inline_img_holder').addClass('hidden')
