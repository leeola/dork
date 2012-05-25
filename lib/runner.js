//
// lib/runner.js
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
  this.fn = fn
  
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
}