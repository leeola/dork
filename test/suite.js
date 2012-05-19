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
      suite = suite_lib()
    })
    
    it('should return a suite object instance', function () {
      // To assert it's identity we're just going to make sure
      // some basic dork functions exist.
      should.exist(suite.add_suite)
      should.exist(suite.add_test)
      should.exist(suite.add_before)
      should.exist(suite.add_after_each)
    })
    
    it('should be a unique object each execution', function () {
      var new_suite = suite_lib()
        , old_suite = suite
      
      old_suite.foo = 'bar'
      should.not.exist(new_suite.foo)
    })
    
    it('should support a single description', function () {
      var description = 'foo'
        , suite = suite_lib(description)
      
      suite.description.should.equal(description)
      should.not.exist(suite.location)
    })
    
    it('should support a description and a location', function () {
      var description = 'foo'
        , location = 'bar'
        , suite = suite_lib(description, location)
      
      suite.description.should.equal(description)
      suite.location.should.equal(location)
    })
  })
  
  describe('#add_suite()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib()
    })
    
    it('should call the given suite\'s fn', function (done) {
      var new_suite = suite_lib(function () {
        done()
      })
      suite.add_suite(new_suite)
    })
    
    // Here we are checking the timing of the scope assignment in the suite.
    it('should set the scope to the newly created suite', function () {
      var fn_called = false
      
      var new_suite = suite_lib(function () {
        suite.scope.should.equal(new_suite)
        fn_called = true
      })
      
      suite.scope.should.equal(suite)
      suite.add_suite(new_suite)
      suite.scope.should.equal(suite)
      
      // And just to be safe, lets make sure the new suite's fn was called.
      // this is tested by an above test, but lets just make sure.
      fn_called.should.be.true
    })
    
    // This is a rather complex test, so for further explanation please see
    // the documentation on Suite.add_suite().
    it('should set the scope to the nested suites', function () {
      var fn_called = false
      
      var suite_a = suite_lib(function () {
        
        var suite_b = suite_lib(function () {
          
          // Finally it's c!
          var suite_c = suite_lib(function () {
            suite.scope.should.equal(suite_c)
            fn_called = true
          })
          
          // Add c
          suite.scope.should.equal(suite_b)
          suite.add_suite(suite_c)
          suite.scope.should.equal(suite_b)
        })
        
        // Add b
        suite.scope.should.equal(suite_a)
        suite.add_suite(suite_b)
        suite.scope.should.equal(suite_a)
      })
      
      // Add a
      suite.scope.should.equal(suite)
      suite.add_suite(suite_a)
      suite.scope.should.equal(suite)
      
      // And just to be safe, lets make sure the new suite's fn was called.
      // this is tested by an above test, but lets just make sure.
      fn_called.should.be.true
    })
  })
  
  describe('#run()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib()
    })
  })
})