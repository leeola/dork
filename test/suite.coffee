#
# test/suite.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
should = require 'should'


# These are here so my IDE will shut the hell up.
before = global.before
before_each = global.beforeEach
describe = global.describe
it = global.it



describe 'Suite', ->
  {Suite} = require '../lib/suite'
  {Runner} = require '../lib/runner'
  {Test} = require '../lib/test'
  
  describe '#()', ->
  
  describe '#_build_session()', ->
    suite = null
    
    before_each ->
      suite = new Suite()
    
    it 'should return an empty list', ->
      suite._build_session().should.eql([])
    
    describe 'With tests', ->
      test_a = test_b = null
      
      before_each ->
        test_a = new Test()
        test_b = new Test()
        suite.add_test test_a
        suite.add_test test_b
      
      it 'it should return [test, test]', ->
        result = suite._build_session()
        result.should.eql([test_a, test_b])
      
      describe 'and befores', ->
        before_a = null
        
        before_each ->
          before_a = new Runner()
          suite.add_before before_a
        
        it 'it should return [before, test, test]', ->
          result = suite._build_session()
          result.should.eql([before_a, test_a, test_b])
