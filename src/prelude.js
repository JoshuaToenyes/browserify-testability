(function outer (modules, cache, entry) {
  
  // Save the require from previous bundle to this closure if any.
  var previousRequire = typeof require == "function" && require;
  
  this._testability_cache_ = {};
  this._restore_cache_ = {};
  this._browserify_cache_ = cache;
  
  function newRequire(name, jumped, reload){
    
    // If passed any doubles, add them to the testability cache and invalidate
    // the cached module that will be requiring the double.
    if (reload) {
      cache[name] = null
    }
    
    // If the cache does not contain this module ID, we need to load it up.
    if(!cache[name]) {
      
      // Check the if the module even exists in this bundle.
      if(!modules[name]) {
        
        // if we cannot find the the module within our internal map or
        // cache jump to the current global require ie. the last bundle
        // that was added to the page.
        var currentRequire = typeof require == "function" && require;
        if (!jumped && currentRequire) return currentRequire(name, true);

        // If there are other bundles on this page the require from the
        // previous one is saved to 'previousRequire'. Repeat this as
        // many times as there are bundles until the module is found or
        // we exhaust the require chain.
        if (previousRequire) return previousRequire(name, true);
        var err = new Error('Cannot find module \'' + name + '\'');
        err.code = 'MODULE_NOT_FOUND';
        throw err;
      }
      
      // Create a new module-like context for this module.
      var m = cache[name] = {exports:{}};

      // Create the require function for this module.
      var req = function(x, reload, restore){
        
        // Get the numeric ID for the module to load.
        var id = modules[name][1][x];
        
        // If there's a matching module in the testability cache, return it.
        if (_testability_cache_[x]) return _testability_cache_[x];
        
        // Return recursively... the module's export will be in the cache 
        // after this.
        return newRequire(id ? id : x, undefined, reload);
      };
      
      // Call the module function within the new module context. Passing it a 
      // reference to it's require function, it's module object, and it's export
      // object (which is just part of the module object.
      //
      // After this call, the result of loading the module will be in the cache
      // object.
      modules[name][0].call(m.exports, req, m, m.exports, outer, modules, cache, entry);
    }
    
    // Return the module's exports object.
    return cache[name].exports;
  }
  
  // Load and run all modules in the bundle, passing the numeric ID to newRequire.
  for(var i=0;i<entry.length;i++) 
    newRequire(entry[i]);

  // Override the current require with this new one
  return newRequire;
})