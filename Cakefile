#
# Cakefile
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
fs = require 'fs'
coffee_script = require './node_modules/coffee-script/lib/coffee-script'
coffee_command = require './node_modules/coffee-script/lib/coffee-script/command'

coffee_build = (args) ->
  argv = process.argv
  args[...0] = argv[0]
  process.argv = args
  coffee_command.run()
  process.argv = argv

task 'build', 'Build', ->
  coffee_build '--compile --output lib/ src/'.split(' ')
