#
# Cakefile
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
fs = require 'fs'
util = require 'util'
path = require 'path'
coffee_script = require './node_modules/coffee-script/lib/coffee-script'
coffee_command = require './node_modules/coffee-script/lib/coffee-script/command'

coffee_build = (args) ->
  argv = process.argv
  args[...0] = argv[0]
  process.argv = args
  console.log 'Uhh..'
  coffee_command.run()
  process.argv = argv

copy_js = (source, output) ->
  console.log "Copying `#{source}` to `#{output}`"
  ins = fs.createReadStream source
  outs = fs.createWriteStream output
  util.pump ins, outs

copy_all_js = (source, output) ->
  if source is undefined
    return
  
  fs.stat source, (err, stats) ->
    #console.log "Stats for.. #{source}"
    if stats.isFile() is true
      if path.extname(source) is '.js'
        copy_js source, output
    else if stats.isDirectory() is true
      fs.readdir source, (err, files) ->
        for file in files
          copy_all_js path.join(source, file), path.join(output, file)

compile = (source, output) ->
  command_args = ['--compile', '--output', output, source]
  coffee_build command_args
  copy_all_js source, output

task 'build', 'Build', ->
  console.log 'Starting build..'
  compile 'lib/', 'build/lib/'
  compile 'foo/', 'build/foo/'
  console.log 'Finished build..'
