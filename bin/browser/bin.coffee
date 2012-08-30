#
# bin/index.coffee
#
# The main browser entry point.
#
# Usage is intended to (optionally) mimick command line functionality.
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
#eggplant = require 'eggplant'
dork = require '../../lib'



###
# Define our options.
eggplant.target 'browser'
eggplant.script 'dork'
eggplant.options
  patterns:
    default: []
    position: 0
    list: true
    help: 'A series of patterns to filter tests by. For additional help, '+
      'see README.md#patterns'
###



# Desc:
#   The function called when `dork()` is used in the browser.
exec = (options) ->
  console.log "Not implemented."




# Note that we are exporting the exec function as main because this "bin"
# is actually a command-line-like entry point, so this function is what
# will be used.
exports = module.exports = exec