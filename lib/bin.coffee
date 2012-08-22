#
# lib/bin.coffee
#
# A node specific entry point for now.
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
path = require 'path'
nomnom = require 'nomnom'
dork = require './index'




nomnom.script 'dork'
nomnom.help 'Start dork tests in the given file or directory with '+
  'optional overriding options.'
nomnom.options
  files:
    default: ['./test']
    abbr: 'f'
    metavar: 'FILE'
    list: true
    help: 'The file or directory to run tests in.'
  
  patterns:
    default: []
    position: 0
    list: true
    help: 'A series of patterns to filter tests by. For additional help, '+
      'see README.md#patterns'




# ([input]) -> undefined
#
# Params:
#   input: Optional. A list of values to parse *in place of* process.argv.
#
# Desc:
#   Execute a dork test based on the arguments provided by either
#   `process.argv` or the `input` argument.
exports.exec = (input) ->
  # Parse the opts, with a possible input override.
  opts = nomnom.parse input
  
  for file in opts.files
    # Resolve the path relative to the cwd.
    file = path.join process.cwd(), file
    
    # Import the target file/directory, then simply run dork.
    # All tests within the given file "should" (lol) have defined themselves
    # to the dork instance.
    require file
  
  # Define any patterns provided.
  for pattern in opts.patterns
    dork.pattern pattern
  
  # Now run dork.
  dork.run()
