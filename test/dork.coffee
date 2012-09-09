#
# test/dork.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
should = require './should'




describe 'dork', ->
  dork_lib = require '../lib/dork'
  
  describe '#()', ->
    dork = null
    
    before_each ->
      dork = dork_lib.create()
    
    it 'should return a dork instance', ->
      dork.should.be.an.instanceof dork_lib.Dork
    
    it 'should be a unique object each execution', ->
      new_test = dork_lib.create()
      old_test = dork
      
      old_test.foo = 'bar'
      should.not.exist new_test.foo