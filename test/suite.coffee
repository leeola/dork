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
    
    describe 'With one of each pre/post runner', ->
      before_a = before_each_a = after_a = after_each_a = null
      
      before_each ->
        before_a = new Runner()
        before_each_a = new Runner()
        after = new Runner()
        after_each_a = new Runner()
        suite.add_before before_a
        suite.add_before_each before_each_a
        suite.add_after after_a
        suite.add_after_each after_each_a
      
      it 'it should return an empty list', ->
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
      
      describe 'and a before', ->
        before_a = null
        
        before_each ->
          before_a = new Runner()
          suite.add_before before_a
        
        it 'it should return [before, test, test]', ->
          result = suite._build_session()
          result.should.eql([before_a, test_a, test_b])
      
      describe 'and a before_each', ->
        before_each_a = null
        
        before_each ->
          before_each_a = new Runner()
          suite.add_before_each before_each_a
        
        it 'it should return [before_each, test, before_each, test]', ->
          result = suite._build_session()
          result.should.eql([before_each_a, test_a, before_each_a, test_b])
      
      describe 'and an after', ->
        after_a = null
        
        before_each ->
          after_a = new Runner()
          suite.add_after after_a
        
        it 'it should return [test, test, after]', ->
          result = suite._build_session()
          result.should.eql([test_a, test_b, after_a])
      
      describe 'and an after_each', ->
        after_each_a = null
        
        before_each ->
          after_each_a = new Runner()
          suite.add_after_each after_each_a
        
        it 'it should return [test, after_each, test, after_each]', ->
          result = suite._build_session()
          result.should.eql([test_a, after_each_a, test_b, after_each_a])
      
      describe 'and a subsuite', ->
        subsuite_a = null
        
        before_each ->
          subsuite_a = new Suite()
          suite.add_suite subsuite_a
        
        it 'it should return [test_a, test_b]', ->
          result = suite._build_session()
          result.should.eql([test_a, test_b])
        
        describe ', now to the subsuite add a test', ->
          subtest_a = null
          
          before_each ->
            subtest_a = new Test()
            subsuite_a.add_test subtest_a
          
          it 'it should return [test_a, test_b, subtest_a]', ->
            result = suite._build_session()
            result.should.eql([test_a, test_b, subtest_a])
          
          describe 'and a before_each', ->
            subbefore_each = null
            
            before_each ->
              subbefore_each = new Runner()
              subsuite_a.add_before_each subbefore_each
            
            it 'it should return [test_a, test_b, subbefore_each, subtest_a]', ->
              result = suite._build_session()
              result.should.eql([test_a, test_b, subbefore_each, subtest_a])
            
            describe '. Now, add a before_each to the root suite', ->
              before_each_a = null
              
              before_each ->
                before_each_a = new Runner()
                suite.add_before_each before_each_a
              
              it 'it should return [before_each_a, test_a, before_each_a, '+
                  'test_b, before_each_a, subbefore_each, subtest_a]', ->
                result = suite._build_session()
                result.should.eql([before_each_a, test_a, before_each_a,
                  test_b, before_each_a, subbefore_each, subtest_a])
    
    describe 'With a complicated catch-all suite/test/runner example', ->
      root_before = null
      root_after_each = null
      root_test = null
      suba_suite = subb_suite = null
      suba_before = suba_after = null
      suba_before_each = null
      suba_test_a = suba_test_b = null
      subb_test = null
      
      before_each ->
        root_before = new Runner()
        root_after_each = new Runner()
        root_test = new Test()
        suba_suite = new Suite()
        subb_suite = new Suite()
        suba_before = new Runner()
        suba_before_each = new Runner()
        suba_after = new Runner()
        suba_test_a = new Test()
        suba_test_b = new Test()
        subb_test = new Test()
        
        suite.add_before root_before
        suite.add_after_each root_after_each
        suite.add_test root_test
        suite.add_suite suba_suite
        suite.add_suite subb_suite
        suba_suite.add_before suba_before
        suba_suite.add_before_each suba_before_each
        suba_suite.add_after suba_after
        suba_suite.add_test suba_test_a
        suba_suite.add_test suba_test_b
        subb_suite.add_test subb_test
      
      it 'should return the expected result.', ->
        result = suite._build_session()
        
        # This dict and loop will help us debug any issues that arrise.
        names =
          root_before: root_before
          root_after_each: root_after_each
          root_test: root_test
          suba_suite: suba_suite
          subb_suite: subb_suite
          suba_before: suba_before
          suba_before_each: suba_before_each
          suba_after: suba_after
          suba_test_a: suba_test_a
          suba_test_b: suba_test_b
          subb_test: subb_test
        
        named_results = []
        for r in result
          match = 'unknown'
          for name, val of names
            if val is r
              match = name
          named_results.push match
        
        named_results.should.eql([
          'root_before', 'root_test', 'root_after_each',
          'suba_before', 'suba_before_each', 'suba_test_a', 'root_after_each',
          'suba_before_each', 'suba_test_b', 'root_after_each', 'suba_after',
          'subb_test', 'root_after_each'])
  
  describe '#add_suite()', ->
    suite = null
    
    before_each ->
      suite = new Suite()
    
    it 'should append the suite to the stack', ->
      new_suite = new Suite()
      suite.add_suite new_suite
      suite._tests_and_suites.should.eql([new_suite])
  
  describe '#add_test()', ->
    suite = new_test = null
    
    before_each ->
      suite = new Suite()
      new_test = new Test()
    
    it 'should append the test to the stack', ->
      suite.add_test new_test
      suite._tests_and_suites.should.eql([new_test])
  
  describe '#add_after()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_after runner
      suite._afters.should.eql([runner])
  
  describe '#add_after_eachs()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_after_each runner
      suite._after_eachs.should.eql([runner])
  
  describe '#add_before()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_before runner
      suite._befores.should.eql([runner])
  
  describe '#add_before_eachs()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_before_each runner
      suite._before_eachs.should.eql([runner])
    
