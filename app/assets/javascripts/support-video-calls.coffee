TS.utility.calls.launchVideoCall = (call_info) ->
  window.open(TS.boot_data.team_url + "call/" + call_info.id)
