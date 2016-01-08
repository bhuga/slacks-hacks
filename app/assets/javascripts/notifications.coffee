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
  console.log("Marking #{TS.channels.getChannelById(TS.model.active_channel_id).name} as viewed")
  channelsViewedAt[TS.model.active_channel_id] = (Date.now() / 1000.0)

previousTotal = 0

setInterval ->
  total = 0

  $("#channel-list .unread_highlight").each (_, el) ->
    total += parseInt($(el).text())
  $("#im-list .unread_highlight").each (_, el) ->
    total += parseInt($(el).text())

  # This can cause weird re-bounces in situations like reading messages in
  # another window, but this is a lot easier than error-prone individual message
  # checking.
  if total > 0 && total != previousTotal
    dock.bounce()
    dock.badge(total.toString())
  else if total == 0
    dock.badge("")

  previousTotal = total;
, 2000
