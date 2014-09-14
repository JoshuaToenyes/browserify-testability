module.exports = require './testability'

# Prevent Browserify from including ./plugin
if require.cache
  module.exports.plugin = require './plugin'
