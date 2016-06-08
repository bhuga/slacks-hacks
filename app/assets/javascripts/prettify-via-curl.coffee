window.prettifyJsCommand = ->
  urls = $('script').map (_, script) ->
    $(script).attr('src')

  jsUrls = _.filter (urls), (url) ->
    (url.indexOf("slack-edge")!= -1) && (url.lastIndexOf("js") == url.length - 2)

  commands = jsUrls.map (url) ->
    fields = url.split("/")
    basename = fields[fields.length - 1]
    "curl -s #{url} | js-beautify > #{basename}"

  command = commands.join "  ; and  "
  input = $("<textarea style='display:block'>#{command}</textarea>")
  $('body').append(input)
  input.get(0).select()
  document.execCommand("copy")
  input.remove()

  console.log "Paste your clipboard into the shell"
