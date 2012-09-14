#
# Cakefile
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
fs = require 'fs'
path = require 'path'
{spawn} = require 'child_process'
util = require 'util'

bork = require 'bork'
Walker = require 'walker'



BROWSERIFY_BIN = './node_modules/browserify/bin/cmd.js'
COFFEE_BIN = './node_modules/coffee-script/bin/coffee'
DORK_BIN = './node_modules/dork/build/bin/dork.js'



# (cmd, args=[], callback=->) -> undefined
#
# Params:
#   cmd: The command to execute.
#   args: A list of args to pass to the process
#   callback: Callback on process exit.
#
# Desc:
#   A simple process launcher that streams output.
exec = (cmd, args=[], cb=->) ->
  bin = spawn cmd, args
  bin.stdout.on 'data', (data) ->
    process.stdout.write data
  bin.stderr.on 'data', (data) ->
    process.stderr.write data
  bin.on 'exit', cb

# (source, output, match=->true, callback=->) -> undefined
#
# Params:
#   source: The source of the copy.
#   output: The output for the copy.
#   match: A match function for the files. Return true if a match, false if
#     no match.
#   callback: Called when all copies are complete.
#
# Desc:
#   Copy files recursively based on a match function.
copy = (source, output, match=(->true), callback=->) ->
  # Our root Bork task
  bork_task = bork()
  bork_task.seq -> callback()
  
  # Define our fs logic for copying
  copy_file = (file_source, callback) ->
    file_output = path.join output, path.relative(source, file_source)
    ins = fs.createReadStream file_source
    ous = fs.createWriteStream file_output
    util.pump ins, ous, callback
  
  # Set up our dir walker
  walker = Walker source
  walker.on 'file', (file, stat) ->
    if match(file)
      bork_task.link (done) -> copy_file file, done
  walker.on 'end', ->
    bork_task.start()


# (source, output, callback) -> undefined
#
# Params:
#   source: The source file/directory.
#   output: The output file/directory.
#   callback: Callback for when it's all finished.
#
# Desc:
#   A shorthand function for copy() and calling exec COFFEE_BIN.
copy_compile = (source, output, callback) ->
  bork_task = bork()
  
  coffee_task = bork_task.seq (done) ->
    exec COFFEE_BIN, ['-co', output, source], -> done()
  
  coffee_task.seq (done) ->
    copy source, output,
      (file) ->
        if path.extname(file) is '.coffee'
          return false
        else
          return true
      -> callback()
  
  bork_task.start()

# We're using bork tasks to get around the horrible async support in Cake
# currently.
bork_task = bork()

task 'build', 'build all', ->
  invoke 'build:bin'
  invoke 'build:browser'
  invoke 'build:lib'
  invoke 'build:test'
  bork_task.start()

task 'build:bin', 'build bin', ->
  console.log 'build:bin start()'
  bork_task.link (done) -> copy_compile './bin', './build/bin', ->
    console.log 'build:bin end'
    done()

task 'build:browser', 'build browser', ->
  bork_task.link (done) ->
    console.log 'build:browser start()'
    exec BROWSERIFY_BIN, ['./browser/dork.coffee', '-o',
        'build/browser/dork.js'], ->
      console.log 'build:browser end'
      done()

task 'build:lib', 'build lib', ->
  console.log 'build:lib start()'
  bork_task.link (done) -> copy_compile './lib', './build/lib', ->
    console.log 'build:lib end'
    done()

task 'build:test', 'build test', ->
  console.log 'build:test start()'
  bork_task.link (done) -> copy_compile './test', './build/test', ->
    console.log 'build:test end'
    done()

task 'test', 'build test, then run it', ->
  invoke 'build:test'
  invoke 'test:nobuild'
  bork_task.start()

task 'test:full', 'build test, then run it', ->
  invoke 'build:browser'
  invoke 'build:bin'
  invoke 'build:lib'
  invoke 'build:test'
  invoke 'test:nobuild'
  bork_task.start()

task 'test:nobuild', 'just run the tests, don\'t build anything', ->
  bork_task.seq (done) ->
    console.log 'test start'
    exec DORK_BIN, ['-f ./build/test'], ->
      console.log 'test done'
      done()

task 'prepublish', 'build all, test all. designed to work before `npm publish`', ->
  invoke 'build:browser'
  invoke 'build:bin'
  invoke 'build:lib'
  invoke 'build:test'
  invoke 'test:nobuild'
  bork_task.start()

