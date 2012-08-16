#
# lib/dork.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
{Suite} = require './suite'
{Test} = require './test'
{StdoutReporter} = require




DEFAULT_OPTIONS =
  global: false
  #reporters: [StdoutReporter]



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
  
  after_all: =>
  
  after_each: =>
  
  before_all: =>
  
  before_each: =>
  
  describe: (description, context_fn) =>
    @_active_suite = new Suite description
    
    context_fn()
  
  it: (description, test_fn) =>
    @_active_suite.add_test = new Test description
  
  options: (options={}) ->
    for k, v of options
      if @["_option_#{k}"]? then @["_option_#{k}"](v)
  
  run: ->




exports.create = (args...) -> new Dork args...
exports.Dork = Dork