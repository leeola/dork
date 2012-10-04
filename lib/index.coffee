#
# lib/index.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#



# Desc:
#   A simple function to initialize this library file, with an optional `ghost`
#   argument. The idea behind ghosting is to allow the
#   `dork -i someones_modules/dork/lib` feature to exist. 
__initialize = (ghost) ->
  if ghost?
    exports = module.exports = ghost
  else
    dork = require './dork'
    
    
    # Our cached instance of a dork test session.
    dork_session = undefined
    if dork_session is undefined
      dork_session = dork.create()
    
    
    # Now assign the session as the root object to the library.
    # This will allow `require('dork').describe()` usage, allowing for
    # a simple and Mocha consistent-ish interface.
    exports = module.exports = dork_session
    
    
    exports.__initialize = __initialize
    exports.dork = dork
    exports.reporters = require './reporters'
    exports.runner = require './runner'
    exports.suite = require './suite'
    exports.test = require './test'
    exports.utils = require './utils'


# Now expose our exports.
__initialize()