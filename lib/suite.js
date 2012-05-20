//
// lib/suite.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var utils = require('./utils')


// (description, location) -> function
//
// Params:
//  description: The description of the suite being created. Undefined is
//    allowed.
//  location: The location of the suite being created Undefined is allowed.
//
// Returns:
//  A new instance of a suite.
//
// Desc:
//  Create a tork instance.
exports = module.exports = function (description, location) {
  var suite = {}
  
  utils.merge(suite, proto)
  suite.init(description, location)
  return suite
}

// The 'prototype' for our object
var proto = exports.proto = {}

// (description, location) -> function
//
// Params:
//  description: The description of the suite being created. Undefined is
//    allowed.
//  location: The location of the suite being created Undefined is allowed.
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function (description, location) {
  this.before_stack = []
  this.before_each_stack = []
  this.after_stack = []
  this.after_each_stack = []
  this.stack = []
  
  this.description = description
  this.location = location
}

// (fn) -> undefined
//
// Params:
//  fn: The after function being added.
//
// Desc:
//  Add an after function that will be called once, after all tests.
proto.add_after = function (fn) {
  this.after_stack.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The after-each function being added.
//
// Desc:
//  Add an after each function that will be called after each test is called.
proto.add_after_each = function (fn) {
  this.after_each_stack.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The before function being added.
//
// Desc:
//  Add a before function that will be called once, before all tests.
proto.add_before = function (fn) {
  this.before_stack.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The before each function being added.
//
// Desc:
//  Add a before-each function that will be called before each test.
proto.add_before_each = function (fn) {
  this.before_each_stack.push(fn)
}

// (suite) -> undefined
//
// Params:
//  suite: The suite being added.
//
// Desc:
//  Add a suite to this suite.
proto.add_suite = function (suite) {
  this.stack.push(suite)
}

// (test) -> undefined
//
// Params:
//  test: The test being added.
//
// Desc:
//  Add a test to this suite.
proto.add_test = function (test) {
  this.stack.push(test)
}

