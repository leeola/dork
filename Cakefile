#
# Cakefile
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
fs = require 'fs'
util = require 'util'
path = require 'path'
{exec} = require 'child_process'
coffee_script = require 'coffee-script'
coffee_command = require './node_modules/coffee-script/lib/coffee-script/command'

coffee_build = (args) ->
  argv = process.argv
  args[...0] = argv[0]
  process.argv = args
  coffee_command.run()
  process.argv = argv

copy_js = (source, output) ->
  ins = fs.createReadStream source
  outs = fs.createWriteStream output
  util.pump ins, outs

compile_coffee = (source, output) ->
  fs.readFile source, 'utf8', (err, data) ->
    compiled = coffee_script.compile data
    fs.writeFile output, compiled

compile_dir = (source, output) ->
  if source is undefined
    return
  
  fs.stat source, (err, stats) ->
    if stats.isFile() is true
      if path.extname(source) is '.js'
        copy_js source, output
      else if path.extname(source) is '.coffee'
        output = "#{output[...-7]}.js"
        compile_coffee source, output
    else if stats.isDirectory() is true
      fs.readdir source, (err, files) ->
        for file in files
          compile_dir path.join(source, file), path.join(output, file)

compile = (source, output) ->
  command_args = ['--compile', '--output', output, source]
  #coffee_build command_args
  compile_dir source, output

task 'build', 'Build', ->
  compile 'foo/', 'build/foo/'
  compile 'lib/', 'build/lib/'
