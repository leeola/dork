//
// lib/runner.js
//
// The runner is a generic object to wrap a function. It allows for
// async or sync functions via an optional callback in the function.
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var utils = require('./utils')


// (fn) -> object
//
// Params:
//  fn: The function this runner will.. run.
//  timeout: How long this runner will take to timeout.
//
// Returns:
//  A new instance of a runner.
//
// Desc:
//  Create a runner instance.
exports.create = function (fn, timeout) {
  var runner = {}
  
  utils.merge(runner, proto)
  runner.init(fn, timeout)
  return runner
}

// The 'prototype' for our object
var proto = exports.proto = {}

// (fn) -> undefined
//
// Params:
//  fn: The function this runner instance will run.
//  timeout: How long this runner will take to timeout.
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function (fn, timeout) {
  if (timeout === undefined) {
    timeout = 2000
  }
  
  // The function this object will eventually run.
  this._fn = fn
  // How long this runner will take to timeout.
  this._timeout = timeout
  
  // An informative var. If function has defined the async 1st argument
  // callback, this will be true. Otherwise it will be false.
  if (fn !== undefined) {
    this.sync = fn !== fn.length !== 1 ? true : false
  }
}

// (callback) -> undefined
//
// Params:
//  callback: A callback which will called upon completion of this test. It
//    will be given a report object filled with information from the test.
//
// Desc:
//  Run this runner.
proto.run = function (callback) {
  var self = this
    , running = true
    , start_time
  
  // If the fn was not given, callback and return immediately.
  if (this._fn === undefined) {
    callback({
        'description': this.description
      , 'success': true
    })
    return undefined
  }
  
  // Our `this._fn` callback
  var done = function () {
    if (running) {
      running = false
      callback({
          'description': this.description
        , 'success': true
        , 'time': new Date() - start_time
      })
    }
  }
  
  // The timeout function.
  var timeout_callback = function () {
    if (running) {
      running = false
      callback({
          'description': this.description
        , 'success': false
        , 'time': new Date() - start_time
      })
    }
  }
  
  try {
    start_time = new Date()
    this._fn(done)
    setTimeout(timeout_callback, this._timeout)
  } catch (error) {
    running = false
    callback({
        'description': this.description
      , 'error': error
      , 'stack': error.stack
      , 'success': false
      , 'time': new Date() - start_time
    })
    return undefined
  }
  
  // Call done() immediately if `this._fn` has not defined the async callback
  if (this._fn.length === 0) {
    done()
  }
}