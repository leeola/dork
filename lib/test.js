//
// lib/test.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var runner = require('./runner')
  , utils = require('./utils')


// (description, location) -> object
//
// Params:
//  description: The description of the test being created. Undefined is
//    allowed.
//  location: The location of the test being created. Undefined is allowed.
//  fn: The test function.
//
// Returns:
//  A new instance of a suite.
//
// Desc:
//  Create a test instance.
exports.create = function (description, location, fn, timeout) {
  var test = {}
  
  // Merge in the runner object, and initialize.
  //
  // Note this this method of creation/inheritance is going to be replaced
  // once i find a method that isn't ugly and is true to javascript.. if
  // that's even possible.
  utils.merge(test, runner.proto)
  test.init_runner = test.init
  
  utils.merge(test, proto)
  test.init(description, location, fn)
  return test
}

// The 'prototype' for our object
var proto = exports.proto = {}

// (description, location) -> undefined
//
// Params:
//  description: The description of the test being created. Undefined is
//    allowed.
//  location: The location of the test being created Undefined is allowed.
//  fn: The test function.
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function (description, location, fn, timeout) {
  this.init_runner(fn, timeout)
  
  this.description = description
  this.location = location
}
