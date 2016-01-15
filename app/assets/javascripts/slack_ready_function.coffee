window.slackReadyFunction = (func) ->
  TS.groups.message_received_sig.add func
  TS.channels.message_received_sig.add func
  TS.ims.message_received_sig.add func
  TS.channels.switched_sig.add func
  TS.groups.switched_sig.add func
  TS.ims.switched_sig.add func
  func()
