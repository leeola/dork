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
      should.exist(runner._timeout)
    })
    
    it('should be a unique object each execution', function () {
      var new_runner = runner_lib.create()
        , old_runner = runner
      
      old_runner.foo = 'bar'
      should.not.exist(new_runner.foo)
    })
  })
  
  describe('#run()', function () {
    var runner
    
    describe('No fn,', function () {
      before_each(function () {
        runner = runner_lib.create()
      })
      
      it('should callback immediately', function () {
        var called = false
        runner.run(function () { called = true })
        called.should.be.true
      })
    })
    
    describe('Sync fn,', function () {
      before_each(function () {
        runner = runner_lib.create(function () {})
      })
      
      it('should call back immediately', function () {
        var called = false
        runner.run(function () { called = true })
        called.should.be.true
      })
    })
    
    describe('Async fn,', function () {
      
      before_each(function () {
        runner = runner_lib.create(function (done) {
          setTimeout(done, 100) })
      })
      
      // These next two tests basically test the same thing in
      // two mildly different ways.
      it('should not callback immediately', function () {
        var sync = false
        runner.run(function () { sync = true })
        sync.should.be.false
      })
      
      it('should callback async-ish', function (done) {
        var async = false
        runner.run(function () {
          async.should.be.true
          done()
        })
        async = true
      })
    })
    
    describe('Async timeout,', function () {
      
      before_each(function () {
        runner = runner_lib.create(function (done) {
          setTimeout(done, 500) }, 200)
      })
      
      // Timeout testing is a bit tricky. We'll add more as runner shapes up
      it('should timeout if execution time exceeds timeout', function (done) {
        runner.run(function (report) {
          // We need more report object testing in this..
          report.success.should.be.false
          done()
        })
      })
    })
  })
})