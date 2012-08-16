#
# lib/dork.coffee
#
# The dork library allows the more 'presentational' style code we are
# all so familiar with. `describe -> it 'foo', ->` style code is made
# possible by the state stored within the Dork class.
#
# Note that this is just the code. The main Dork instance is stored
# within lib/index, but creating custom Dork sessions will work without
# issue.
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
utils = require './utils'
{Suite} = require './suite'
{Test} = require './test'
{StdoutReporter} = require './reporters'




DEFAULT_OPTIONS =
  global: false
  reporters: [new StdoutReporter()]



class Dork
  constructor: (options={}) ->
    @_options = {}
    @_base_suite = @_active_suite = new Suite()
    
    # Combine the given options with the default options.
    for k, v of DEFAULT_OPTIONS
      if not options[k]? then options[k] = v
    # And call @options to act on the Dork() options.
    @options options
  
  _option_global: (value) ->
    if @_options.global is value then return
    
    if value
      # Note that currently this is destructive. Things go boom
      global.after_all = @after_all
      global.after_each = @after_each
      global.before_all = @before_all
      global.before_each = @before_each
      global.describe = @describe
      global.it = @it
    else if @_options.global?
      # If value is false and we already used global:true
      global.after_all =
        global.after_each =
          global.before_all =
            global.before_each =
              global.describe =
                global.it = undefined
    @_options.global = value
  
  _option_reporters: (user_reporters) ->
    if @_options.reporters?
      rem_reporters = @_options.reporters[..]
      new_reporters = []
      for reporter in user_reporters
        if not (reporter in @_options.reporters)
          new_reporters.push reporter
        else
          index = utils.index_of rem_reporters, reporter
          rem_reporters.splice index, 0
    else
      rem_reporters = []
      new_reporters = user_reporters
    
    # Make the new reporters listen to the base suite.
    for reporter in new_reporters
      console.log 'Listening to reporter!'
      reporter.listen @_base_suite
    
    # And remove the old reporters.
    for reporter in rem_reporters
      reporter.remove @_base_suite
  
  after_all: (fn) =>
    @_active_suite.add_after_all = new Runner fn
  
  after_each: (fn) =>
    @_active_suite.add_after_each = new Runner fn
  
  before_all: (fn) =>
    @_active_suite.add_before_all = new Runner fn
  
  before_each: (fn) =>
    @_active_suite.add_before_each = new Runner fn
  
  describe: (description, context_fn) =>
    old_suite = @_active_suite
    new_suite = new Suite description
    @_active_suite.add_suite new_suite
    
    @_active_suite = new_suite
    context_fn()
    @_active_suite = old_suite
  
  it: (args...) =>
    @_active_suite.add_test new Test args...
  
  options: (options={}) ->
    for k, v of options
      if @["_option_#{k}"]? then @["_option_#{k}"](v)
  
  run: ->
    @_base_suite.run()




exports.create = (args...) -> new Dork args...
exports.Dork = Dork