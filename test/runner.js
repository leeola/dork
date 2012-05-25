//
// test/runner.js
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


describe('runner', function () {
  var runner_lib = require('../lib/runner')
  
  describe('create()', function () {
    var runner
    
    before_each(function () {
      runner = runner_lib.create(function () {})
    })
    
    it('should return a runner object instance', function () {
      // To assert it's identity we're just going to make sure
      // some basic test functions exist.
      should.exist(runner._fn)
    })
    
    it('should be a unique object each execution', function () {
      var new_runner = runner_lib.create()
        , old_runner = runner
      
      old_runner.foo = 'bar'
      should.not.exist(new_runner.foo)
    })
  })
})