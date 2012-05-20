//
// lib/test.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var utils = require('./utils')


// (description, location) -> function
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
//  Create a tork instance.
exports.create = function (description, location, fn) {
  var test = {}
  
  utils.merge(test, proto)
  test.init(description, location, fn)
  return test
}

// The 'prototype' for our object
var proto = exports.proto = {}

// (description, location) -> function
//
// Params:
//  description: The description of the test being created. Undefined is
//    allowed.
//  location: The location of the test being created Undefined is allowed.
//  fn: The test function.
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function (description, location, fn) {
  this.description = description
  this.location = location
  this.fn = fn
}