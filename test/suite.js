//
// test/dork.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed 
//
/*jshint asi: true, laxcomma: true*/
var should = require('should')


// These are here so my IDE will shut the hell up.
var before = global.before
  , before_each = global.beforeEach
  , describe = global.describe
  , it = global.it


describe('suite', function () {
  var suite_lib = require('../lib/suite')
  
  describe('#()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should return a suite object instance', function () {
      // To assert it's identity we're just going to make sure
      // some basic suite functions exist.
      should.exist(suite.add_suite)
      should.exist(suite.add_test)
      should.exist(suite.add_before)
      should.exist(suite.add_after_each)
    })
    
    it('should be a unique object each execution', function () {
      var new_suite = suite_lib.create()
        , old_suite = suite
      
      old_suite.foo = 'bar'
      should.not.exist(new_suite.foo)
    })
    
    it('should support a single description', function () {
      var description = 'foo'
        , suite = suite_lib.create(description)
      
      suite.description.should.equal(description)
      should.not.exist(suite.location)
    })
    
    it('should support a description and a location', function () {
      var description = 'foo'
        , location = 'bar'
        , suite = suite_lib.create(description, location)
      
      suite.description.should.equal(description)
      suite.location.should.equal(location)
    })
  })
  
  describe('#add_suite()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the suite to the stack', function () {
      var new_suite = suite_lib.create('foo', 'bar')
      suite.add_suite(new_suite)
      suite.stack.should.eql([new_suite])
    })
  })
  
  describe('#add_test()', function () {
    var test_lib = require('../lib/test')
      , suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the test to the stack', function () {
      var test = test_lib.create('foo', 'bar')
      suite.add_test(test)
      suite.stack.should.eql([test])
    })
  })
  
  describe('#add_before()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the given function to the before stack', function () {
      var fn = function () {}
      suite.add_before(fn)
      suite.before_stack.should.eql([fn])
    })
  })
  
  describe('#add_before_each()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the given function to the before each stack',
    function () {
      var fn = function () {}
      suite.add_before_each(fn)
      suite.before_each_stack.should.eql([fn])
    })
  })
  
  describe('#add_after()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the given function to the after stack', function () {
      var fn = function () {}
      suite.add_after(fn)
      suite.after_stack.should.eql([fn])
    })
  })
  
  describe('#add_after_each()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should append the given function to the after stack', function () {
      var fn = function () {}
      suite.add_after_each(fn)
      suite.after_each_stack.should.eql([fn])
    })
  })
  
  describe('#run()', function () {
    var test_lib = require('../lib/test')
      , suite
    
    before_each(function () {
      suite = suite_lib.create()
    })
    
    it('should callback with a report', function (done) {
      suite.run(function (report) {
        report.test_count.should.equal(0)
        done()
      })
    })
    
    it('should run all added tests', function (done) {
      var count_a = 0
        , count_b = 0
      suite.add_test(test_lib.create(function () { count_a++ }))
      suite.add_test(test_lib.create(function () { count_b++ }))
      suite.run(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
        done()
      })
    })
    
    it('should call before()s once, before tests', function (done) {
      var count_a = 0
        , count_b = 0
      suite.add_before(function () { count_a++ })
      suite.add_before(function () { count_b++ })
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
      }))
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
      }))
      suite.run(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
        done()
      })
    })
    
    it('should call before_each()\'s before each test', function (done) {
      var count_a = 0
        , count_b = 0
      suite.add_before_each(function () { count_a++ })
      suite.add_before_each(function () { count_b++ })
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
      }))
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(2)
        count_b.should.equal(2)
      }))
      suite.run(function () {
        count_a.should.equal(2)
        count_b.should.equal(2)
        done()
      })
    })
    
    it('should call after()\'s after tests', function (done) {
      var count_a = 0
        , count_b = 0
      suite.add_after(function () { count_a++ })
      suite.add_after(function () { count_b++ })
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(0)
        count_b.should.equal(0)
      }))
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(0)
        count_b.should.equal(0)
      }))
      suite.run(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
        done()
      })
    })
    
    it('should call after_each()\'s after each test', function (done) {
      var count_a = 0
        , count_b = 0
      suite.add_after_each(function () { count_a++ })
      suite.add_after_each(function () { count_b++ })
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(0)
        count_b.should.equal(0)
      }))
      suite.add_test(test_lib.create(function () {
        count_a.should.equal(1)
        count_b.should.equal(1)
      }))
      suite.run(function () {
        count_a.should.equal(2)
        count_b.should.equal(2)
        done()
      })
    })
    
    it('should run all added suites', function () {
      var count = 0
        , sub_suite = suite_lib.create()
      
      // Mock the sub_suite
      sub_suite.run = function () {
        count++
      }
      
      suite.add_suite(sub_suite)
      // Because we mocked `sub_suite.run()` we broke the run callback system.
      // But! It should still run, it will just never return.
      suite.run()
      // So, now after our suite has run, it should have called
      // `sub_suite.run()`, triggering our `count++` call. So we're testing
      // for that.
      count.should.equal(1)
    })
  })
})