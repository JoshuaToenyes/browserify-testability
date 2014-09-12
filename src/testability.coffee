
# ======== Module Constants =========

SPLIT_REGEXP = /[\s,\|]+/



# ========= Module Classes ==========

class Testability

  # Constructor takes a reference to the local require function (this is
  # mandatory).
  constructor: (@_require) ->
    @_root = window || global
    @_required = []
    if typeof @_require != 'function'
      throw new Error "Testability Error: No reference to local `require()`
        received. You must pass a local reference to the local require function.
        Try something like `testability = require('testability')(require);`"


  # Loads the passed module and dependency doubles (mocks, stubs, etc.). Mock
  # dependencies passed to this function will be given precedence over the same
  # module path loaded globally via `replace()`.
  require: (module, doubles) ->
    old = {}
    if @_required.indexOf(module) == -1 then @_required.push module
    for ms, d of doubles
      for m in ms.split SPLIT_REGEXP
        if @has m
          old[m] = @get m
        @replace m, d
    e = @_require module, true
    for ms of doubles
      for m in ms.split SPLIT_REGEXP
        @restore m
    for m of old
      @replace m, old[m]
    return e


  # Replaces the passed module path with the given double (mock, stub, etc.).
  # Multiple modules may be replaced if an object is passed. The module paths
  # may also be separated using spaces, commas, or bars.
  replace: (module, double) ->
    if typeof module == 'object'
      for m, d of module
        @_replace m, d
    else
      @_replace module, double


  # Restores the given module path to it's original module.
  restore: (module) ->
    for m in module.split SPLIT_REGEXP
      @_root._testability_cache_[m] = null


  # Clears all registered double modules.
  restoreAll: ->
    @_root._testability_cache_ = {}


  # Returns true if the specified double module is in the setup for replacement.
  has: (m) ->
    !!@_root._testability_cache_[m]


  # Returns the specified module double.
  get: (m) ->
    @_root._testability_cache_[m]


  # Internal-use replacement function.
  _replace: (module, double) ->
    for m in module.split SPLIT_REGEXP
      @_root._testability_cache_[m] = double



# ========= Module Exports ==========

module.exports = (require) ->
  return new Testability(require)
