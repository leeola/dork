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
    
    it('should append the suite to the stack', function (done) {
      var new_suite = suite_lib('foo', 'bar')
      suite.add_suite(new_suite)
      suite.stack.should.equal([new_suite])
    })
  })
  
  describe('#run()', function () {
    var suite
    
    before_each(function () {
      suite = suite_lib()
    })
  })
})