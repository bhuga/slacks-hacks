# TS.client.ui.active_highlight_count
# TS.model.prefs.mac_ssb_bounce, "short" or "long"
# Optimistically, these might be useful from other scripts, so we'll export them?
window.dock = {}

window.dock.bounce = ->
  preference = TS.model.prefs.mac_ssb_bounce
  return unless preference is "long" or preference is "short"
  type = if TS.model.prefs.mac_ssb_bounce == "short" then "informational" else "critical"
  host.ipc.send('bounce', { type: type })

window.dock.badge = (message) ->
  host.ipc.send('badge', { badge_text: message })

# At boot, mark all channels as read once.
window.channelsViewedAt = {}
for channel in TS.model.channels when channel.is_member
  channelsViewedAt[channel.id] = Date.now() / 1000.0
# Mark channels as viewed later
TS.channels.switched_sig.add ->
  channelsViewedAt[TS.model.active_channel_id] = (Date.now() / 1000.0)

dmNotificationsCount = ->
  count = 0
  $("#im-list .unread_highlight").each (_, el) ->
    count += parseInt(el.innerText)
  count

setInterval ->
  name = "@#{TS.model.user.name}"
  total = 0
  # Mark the current channel as viewed to mark notifications sent since we
  # switched. Otherwise notifications for a currently-viewed muted room can
  # stack up.
  channelsViewedAt[TS.model.active_channel_id] = (Date.now() / 1000.0)
  for channel in TS.model.channels when channel.is_member
    count = 0

    last_read = parseFloat(channel.last_read)
    # muted channels show up as 'read' 100% of the time, so no notifications
    # are received. we'll trust our own, only-this-client version for
    # these channels, forgoing slack's nice cross-client notification handling.
    if TS.model.muted_channels.indexOf(channel.id) != -1
      last_read = channelsViewedAt[channel.id] || 0

    for msg in channel.msgs when parseFloat(msg.ts) > last_read
      text = msg.text || msg.attachments[0].text
      if text and text.indexOf(name) != -1
        console.log "found unread mention in #{channel.name}"
        count += 1
    if count > 0
      $(".unread_highlight_#{channel.id}").removeClass('hidden').text(count.toString())
    else
      $(".unread_highlight_#{channel.id}").addClass('hidden').text("")
    total += count

  total += dmNotificationsCount()
  if total > 0
    dock.bounce()
    dock.badge(total.toString())
  else
    dock.badge("")
, 5000
