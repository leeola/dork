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
  
  describe '#add_after_all()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_after_all runner
      suite._after_alls.should.eql([runner])
  
  describe '#add_after_eachs()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_after_each runner
      suite._after_eachs.should.eql([runner])
  
  describe '#add_before_all()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_before_all runner
      suite._before_alls.should.eql([runner])
  
  describe '#add_before_eachs()', ->
    suite = runner = null
    
    before_each ->
      suite = new Suite()
      runner = new Runner()
    
    it 'should append the runner to the stack', ->
      suite.add_before_each runner
      suite._before_eachs.should.eql([runner])

# We're going to try a different approach here to structuring the tests.
# Please bear with us.
describe 'A suite', ->
  {Suite} = require '../lib/suite'
  {Runner} = require '../lib/runner'
  {Test} = require '../lib/test'
  suite = null
  run_log = null
  
  before_each ->
    run_log = []
    suite = new Suite()
  
  # A suite
  describe 'with two tests', ->
    test_count_a = test_count_b = null
    
    before_each ->
      test_count_a = 0
      test_count_b = 0
      suite.add_test new Test -> test_count_a += 1
      suite.add_test new Test -> test_count_b += 1
    
    it 'should run all tests when suite is run', ->
      suite.run()
      test_count_a.should.equal(1)
      test_count_b.should.equal(1)
    
    # with two tests
    describe 'and a subsuite', ->
      subsuite = null
      
      before_each ->
        subsuite = new Suite()
        suite.add_suite subsuite
      
      it 'should run all tests when suite is run', ->
        suite.run()
        test_count_a.should.equal(1)
        test_count_b.should.equal(1)
      
      # with two tests
      # and a subsuite
      describe 'with a test', ->
        test_count_c = null
        
        before_each ->
          test_count_c = 0
          subsuite.add_test new Test -> test_count_c += 1
        
        it 'should run all tests when suite is run', ->
          suite.run()
          test_count_a.should.equal(1)
          test_count_b.should.equal(1)
          test_count_c.should.equal(1)
        
        it 'should run only the subsuite test when subsuite is run', ->
          subsuite.run()
          test_count_a.should.equal(0)
          test_count_b.should.equal(0)
          test_count_c.should.equal(1)
  
  describe 'with a before_all', ->
    
    before_each ->
      suite.add_before_all new Runner -> run_log.push 'suite.before_all'
    
    it 'should not be run with no tests', ->
      suite.run()
      run_log.should.eql([])
    
    # A suite
    # with a before_all
    describe 'and a test', ->
      before_each ->
        suite.add_test new Test -> run_log.push 'suite.test'
      
      it 'should run before_all then test', ->
        suite.run()
        run_log.should.eql([
          'suite.before_all'
          'suite.test'
        ])
