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

# We're going to try a different approach here to structuring the tests.
# Please bear with us.
describe 'A suite', ->
  {Suite} = require '../lib/suite'
  {Runner} = require '../lib/runner'
  {Test} = require '../lib/test'
  suite = null
  
  before_each ->
    suite = new Suite()
  
  describe 'with two tests', ->
    test_count_a = test_count_b = null
    
    before_each ->
      test_count_a = 0
      test_count_b = 0
      
      suite.add_test new Test -> test_count_a += 1
      suite.add_test new Test -> test_count_b += 1
    
    it 'should call each test once when run', ->
      suite.run()
      test_count_a.should.equal(1)
      test_count_b.should.equal(1)
