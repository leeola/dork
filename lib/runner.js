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
//
// Returns:
//  A new instance of a runner.
//
// Desc:
//  Create a runner instance.
exports.create = function (fn, timeout) {
  var runner = {}
  
  utils.merge(runner, proto)
  runner.init(fn)
  return runner
}

// The 'prototype' for our object
var proto = exports.proto = {}

// (fn) -> undefined
//
// Params:
//  fn: The function this runner instance will run.
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function (fn) {
  // The function this object will eventually run.
  this._fn = fn
  
  // An informative var. If function has defined the async 1st argument
  // callback, this will be true. Otherwise it will be false.
  this.sync = fn.length !== 1 ? true : false
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
    callback({
        'description': this.description
      , 'success': true
    })
  }
  
  
  try {
    this._fn(done)
  } catch (error) {
    callback({
        'description': this.description
      , 'error': error
      , 'stack': error.stack
      , 'success': false
    })
    return undefined
  }
  
  // This is commented out because for now, we are not supporting Async in
  // these tests yet.
  //if (this.fn.length === 0)
  done()
}