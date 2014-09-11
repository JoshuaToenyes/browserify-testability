# ====== Module Dependencies ========

_ = require 'underscore'
bpack = require 'browser-pack'
fs    = require 'fs'
path  = require 'path'
transform = require './transform'



# ======== Browserify Plugin ========

module.exports = (browserify, options) ->
  preludePath = path.join __dirname, 'prelude.js'
  packOptions =
    raw: true
    preludePath: preludePath
    prelude: fs.readFileSync preludePath, 'utf8'
  packer = bpack _.extend(browserify._options, packOptions)
  browserify.pipeline.splice 'pack', 1, packer
  browserify.transform transform
