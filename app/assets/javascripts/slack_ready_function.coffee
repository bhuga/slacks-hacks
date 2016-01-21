# 🙈
slackRebuildMsg = TS.client.msg_pane.rebuildMsg
TS.client.msg_pane.rebuild_sig = new signals.Signal
TS.client.msg_pane.rebuildMsg = ->
  slackRebuildMsg()
  TS.client.msg_pane.rebuild_sig.dispatch()

window.slackReadyFunction = (func) ->
  TS.client.msg_pane.rebuild_sig.add func

  for channel_type in ["groups", "channels", "ims", "mpims"]
    TS[channel_type].message_received_sig.add func
    TS[channel_type].switched_sig.add func
    TS[channel_type].history_fetched_sig.add func

  func()
