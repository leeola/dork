//
// test/test.js
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


describe('test', function () {
  var test_lib = require('../lib/test')
  
  describe('#()', function () {
    var test
    
    before_each(function () {
      test = test_lib.create('foo', 'bar', function () {})
    })
    
    it('should return a test object instance', function () {
      // To assert it's identity we're just going to make sure
      // some basic test functions exist.
      should.exist(test.description)
      should.exist(test.fn)
      // And since the test object is not that unique, lets make sure it's
      // not a suite object.
      should.not.exist(test.add_suite)
      should.not.exist(test.add_test)
    })
    
    it('should be a unique object each execution', function () {
      var new_test = test_lib.create()
        , old_test = test
      
      old_test.foo = 'bar'
      should.not.exist(new_test.foo)
    })
  })
})
