#
# test/runner.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
dork = require 'dork'
should = require 'should'
require './options'




describe 'test', ->
  test_lib = require '../lib/test'
  
  describe '#()', ->
    test = null
    
    before_each ->
      test = test_lib.create 'foo', 'bar', ->
    
    it 'should return a test object instance', ->
      test.should.be.an.instanceof test_lib.Test
    
    it 'should be a unique object each execution', ->
      new_test = test_lib.create()
      old_test = test
      
      old_test.foo = 'bar'
      should.not.exist new_test.foo
  
  describe '#run()', ->
    
    describe 'passing test, ', ->
      test = null
      
      before_each ->
        test = test_lib.create 'foo', 'bar', ->
      
      # At the moment the report object is in early design.. so lets just
      # test the basics of it while the code shapes up.
      it 'should return report object', ->
        report = null
        
        test.run (r) -> report = r
        
        report.success.should.be.true
    
    describe 'thrown error test, ', ->
      test = null
      
      before_each ->
        test = test_lib.create 'foo', 'bar', ->
          throw new Error 'Fail Test'
      
      it 'should return report object', ->
        report = null
        
        test.run (r) -> report = r
        
        report.success.should.be.false




if require.main is module then dork.run()