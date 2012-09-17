#
# test/suite.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
dork = require 'dork'
should = require 'should'
require './options'




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
  
  describe '#run()', ->
    run_log = null
    
    before_each -> run_log = []
    
    it 'should callback immediately when empty', ->
      suite = new Suite()
      suite.run -> run_log.push 'run callback'
      
      run_log.should.equal ['run callback']
    
    it 'should delay calling back until the tests are done', (done) ->
      suite = new Suite()
      suite.add_test (done) ->
        run_log.push 'test'
        # Only a tiny timeout is needed, to make it "async"
        setTimeout done, 100
      
      suite.run ->
        run_log.push 'run callback'
        
        # Now, inside the run() callback, ensure our run_log is expected.
        run_log.should.equal [
          'test'
          'run callback'
        ]
        done()

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
  
  # A suite
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
    
    # A suite
    # with a before_all
    describe 'and a subsuite', ->
      subsuite = null
      before_each ->
        subsuite = new Suite()
        suite.add_suite subsuite
      
      it 'should not run anything with no tests', ->
        suite.run()
        run_log.should.eql([])
      
      describe 'with tests', ->
        before_each ->
          subsuite.add_test new Test -> run_log.push 'subsuite.test_a'
          subsuite.add_test new Test -> run_log.push 'subsuite.test_b'
        
        it 'should run before_all then the subsuite tests', ->
          suite.run()
          run_log.should.eql([
            'suite.before_all'
            'subsuite.test_a'
            'subsuite.test_b'
          ])
  
  # A suite
  describe 'with a before_each', ->
    before_each ->
      suite.add_before_each new Runner -> run_log.push 'suite.before_each'
    
    it 'should not be run with no tests', ->
      suite.run()
      run_log.should.eql([])
  
  # A suite
  describe 'with an after_all', ->
    before_each ->
      suite.add_after_all new Runner -> run_log.push 'suite.after_all'
    
    it 'should not be run with no tests', ->
      suite.run()
      run_log.should.eql([])
  
  # A suite
  describe 'with an after_each', ->
    before_each ->
      suite.add_after_each new Runner -> run_log.push 'suite.after_each'
    
    it 'should not be run with no tests', ->
      suite.run()
      run_log.should.eql([])


# This is our catch-all test. Because there are a *lot* of possibilities
# with this set of tests, we're going to do a bunch of random tests,
# and one test that does one of everything.
# A suite
describe 'A suite with a kitchen sink', ->
  {Suite} = require '../lib/suite'
  {Runner} = require '../lib/runner'
  {Test} = require '../lib/test'
  run_log = null
  suite = subsuite = subsubsuite = subsuite_b = null
  
  before_each ->
    run_log = []
    suite = new Suite()
    subsuite = new Suite()
    subsubsuite = new Suite()
    subsuite_b = new Suite()
    
    suite.add_before_all new Runner -> run_log.push 'suite.before_all_a'
    suite.add_before_all new Runner -> run_log.push 'suite.before_all_b'
    suite.add_before_each new Runner -> run_log.push 'suite.before_each'
    suite.add_test new Test -> run_log.push 'suite.test_a'
    suite.add_test new Test -> run_log.push 'suite.test_b'
    suite.add_after_each new Runner -> run_log.push 'suite.after_each'
    suite.add_after_all new Runner -> run_log.push 'suite.after_all'
    suite.add_suite subsuite
    suite.add_suite subsuite_b
    subsuite.add_suite subsubsuite
    subsuite.add_before_all new Runner -> run_log.push 'subsuite.before_all'
    subsuite.add_before_each new Runner -> run_log.push 'subsuite.before_each'
    subsuite.add_test new Test -> run_log.push 'subsuite.test'
    subsuite.add_after_all new Runner -> run_log.push 'subsuite.after_all'
    subsuite.add_after_each new Runner -> run_log.push 'subsuite.after_each'
    subsubsuite.add_test new Test -> run_log.push 'subsubsuite.test'
    subsuite_b.add_before_all new Runner -> run_log.push 'subsuite_b.before_all'
  
  it 'should match the expected result when running suite', ->
    suite.run()
    # The following is a handy debugger.
    #console.log 'run log: '
    #for log in run_log
    #  console.log log
    run_log.should.eql([
      'suite.before_all_a'
      'suite.before_all_b'
      'suite.before_each'
      'suite.test_a'
      'suite.after_each'
      'suite.before_each'
      'suite.test_b'
      'suite.after_each'
      
      'subsuite.before_all'
      'suite.before_each'
      'subsuite.before_each'
      'subsubsuite.test'
      'subsuite.after_each'
      'suite.after_each'
      
      'suite.before_each'
      'subsuite.before_each'
      'subsuite.test'
      'subsuite.after_each'
      'suite.after_each'
      'subsuite.after_all'
      'suite.after_all'
      ])
  
  it 'should match the expected result when running subsuite', ->
    subsuite.run()
    run_log.should.eql([
      'subsuite.before_all'
      'subsuite.before_each'
      'subsubsuite.test'
      'subsuite.after_each'
      
      'subsuite.before_each'
      'subsuite.test'
      'subsuite.after_each'
      'subsuite.after_all'
      ])
  
  it 'should match the expected result when running subsubsuite', ->
    subsubsuite.run()
    run_log.should.eql([
      'subsubsuite.test'
      ])
  
  it 'should match the expected result when running subsuite_b', ->
    subsuite_b.run()
    run_log.should.eql([])




if require.main is module then dork.run()