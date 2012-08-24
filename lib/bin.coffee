#
# lib/bin.coffee
#
# A node specific entry point for now.
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
fs = require 'fs'
path = require 'path'
nomnom = require 'nomnom'
resolve = require 'resolve'



# A node version fix.
if path.existsSync?
  existsSync = path.existsSync
else
  existsSync = fs.existsSync




nomnom.script 'dork'
nomnom.help 'Start dork tests in the given file or directory with '+
  'optional overriding options.'
nomnom.options
  coffee:
    abbr: 'c'
    choices: [true, false]
    help: 'By default, Dork attempts to automatically support the importing '+
      'of coffee files. If `false`, this action is suppressed. If '+
      '`true`, this action is forced. Note that CoffeeScript must be '+
      'installed independantly for this feature to work at all.'
  
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
exec = (input) ->
  # Parse the opts, with a possible input override.
  opts = nomnom.parse input
  
  # If the user specified coffee usage, import immediately.
  if opts.coffee is true
    import_coffee()
  
  for user_file in opts.files
    # Resolve the path relative to the cwd.
    file = path.join process.cwd(), user_file
    
    # Check if the file specified by the user even exists.
    if not existsSync(file)
      # Compensate for user shorthand.
      if path.extname(file) is '' and existsSync "#{file}.js"
          file = "#{file}.js"
      else if path.extname(file) is '' and existsSync "#{file}.coffee"
          file = "#{file}.coffee"
      else
        throw new Error "The file '#{user_file}' does not exist."
    
    # If the user didn't specify a coffee option, attempt to figure
    # out if the file is CoffeeScript. The below code also supports
    # specifying a directory with a coffee index file.
    if opts.coffee is undefined
      stat = fs.statSync file
      if stat.isFile() and path.extname(file) is '.coffee'
        import_coffee()
      else if stat.isDirectory()
        # We aren't catching the error here, because we don't care.
        # If the filename we made up doesn't exist, move on.
        try
          index_file = path.join file, 'index.coffee'
          stat = fs.statSync index_file
          if path.extname(index_file) is '.coffee'
            import_coffee()
    
    
    # Import the target file/directory, then simply run dork.
    # All tests within the given file "should" (lol) have defined themselves
    # to the dork instance.
    require file
    
    # Now import the dork session based on the locally installed dork.
    # This is done because Dork stores it's sessions in the index module
    # of the local dork package. If this bin is installed globally via
    # `npm install -g dork` then `require './index'` will return the *wrong
    # dork instance*!
    # To solve this issue, we use the same dork module that the target file
    # should be using when it calls `require 'dork'`.
    dirname = path.dirname file
    dork = require resolve.sync 'dork', basedir: dirname
    
    # Define any patterns provided.
    for pattern in opts.patterns
      dork.pattern pattern
    
    # Now run dork.
    dork.run()


# Desc:
#   A simple function to attempt to import coffee, or fail with a meaningful
#   message if coffee is not found.
import_coffee = ->
  try
    require 'coffee-script'
  catch e
    if e.message is "Cannot find module 'coffee-script'"
      throw new Error 'CoffeeScript must be installed manually to test '+
        '.coffee files.'
    else
      throw e




exports.exec = exec