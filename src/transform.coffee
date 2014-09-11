through = require 'through'

module.exports = ->

  headerWritten = false
  injected = {}

  regexps = [
    /@testability\s*require\s*([\w\/\.\-\~\@]+)/g
    /testability\.require\s*\(['"]([\w\/\.\-\~\@]+)['"]/g
  ]

  header = (buf) ->
    headerWritten = true
    "\n\n/* Testability Injected Dependencies */\n"

  footer = (buf) ->
    if headerWritten then "/* End Injected Dependencies */\n" else ''

  inject = (m) ->
    console.log injected
    if injected[m] then '' else injected[m] = "require('#{m}');\n"

  write = (buf) ->
    src = buf.toString()
    for r in regexps
      while ms = r.exec src
        if not headerWritten then buf += header()
        buf += inject(ms[1])
    buf += footer()
    this.emit('data', buf)

  return through(write)