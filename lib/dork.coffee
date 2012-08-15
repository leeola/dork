#
# lib/dork.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
suite = require './suite'
test = require './test'




class Dork
  constructor: ->
    @_active_suite = new suite.Suite()
  
  after_all: ->
  
  after_each: ->
  
  before_all: ->
  
  before_each: ->
  
  describe: ->
  
  it: ->




exports.create = (args...) -> new Dork args...
exports.Dork = Dork