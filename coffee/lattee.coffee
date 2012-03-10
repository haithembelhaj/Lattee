$ ->
  window.editor = ace.edit "terminal"
  sourceFragment = "lattee:"
  editor.setTheme "ace/theme/solarized_light"
  JavaScriptMode = require("ace/mode/coffee").Mode
  editor.getSession().setMode new JavaScriptMode()

  # Set up the compilation function, to run when you stop typing.
  compileSource = ->
    source = editor.getSession().getValue()
    window.compiledJS = ''
    try
      window.compiledJS = CoffeeScript.compile source, bare: on
      $('#compiled pre code').html window.compiledJS
      $('#compiled pre code').each (i,e)-> hljs.highlightBlock e, '    '
      $('#error').hide()
    catch error
      $('#error').text(error.message).css("color", "red").show()

    # Update permalink
    $('#share').attr 'href', "##{sourceFragment}#{encodeURIComponent source}"
    $('#save').attr 'href', "data:text/coffeescript;charset=utf-8;base64,#{Base64.encode source}"

  # Listen for keypresses and recompile.
  editor.getSession().on 'change' , -> compileSource()

  # Eval the compiled js.
  window.evalJS = ->
    try
      console.log 'evaluating'
      eval window.compiledJS
    catch error then alert error

  # Load the console with a string of CoffeeScript.
  window.loadConsole = (coffee) ->
    editor.getSession().setValue coffee
    compileSource()
    false

  #loggin and error
  window.onerror = (msg , url, line)->
    $('#error').text("msg:#{msg} url:#{url} line:#{line}").css("color", "red").show()
    
  log = (msg)->
    $('#error').text("#{msg}").css("color", "black").show()


  # Trigger Run button on Ctrl-X
  $(document.body)
    .keydown (e) -> 
      evalJS() if e.which == 88 and (e.metaKey or e.ctrlKey)

  $('#share').click (e) ->
    window.location = $(this).attr("href")
    false

  $('#run').click (e) ->
    window.evalJS()
    false

  sourceFragment
  # If source code is included in location.hash, display it.
  hash = decodeURIComponent location.hash.replace(/^#/, '')
  if hash.indexOf(sourceFragment) == 0
      src = hash.substr sourceFragment.length
      loadConsole src

  compileSource()


