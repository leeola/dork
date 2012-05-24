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
exports.create = function (description, location) {
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
  this.befores = []
  this.before_eachs = []
  this.afters = []
  this.after_eachs = []
  this.stack = []
  
  this.description = description
  this.location = location
}

proto._build_session = function (befores, before_eachs, after_eachs, stack, index) {
  if(arguments.length === 0) {
    befores = before_eachs = after_eachs = stack = []
    index = 0
  }
  
  if (index === 0) {
    befores = befores.concat(this.befores)
    before_eachs = before_eachs.concat(this.before_eachs)
    after_eachs = this.after_eachs.concat(after_eachs)
  }
  
  
  var item = this.stack[index]
  
  
  if (item === undefined) {
    if (stack.length > 0) {
      stack = stack.concat(this.afters)
    }
    return stack
  }
  
  if (item._build_session !== undefined) {
    var returned_stack = item._build_session(befores, before_eachs, after_eachs, [], 0)
    
    if (returned_stack.length > 0) {
      befores = []
      stack = stack.concat(returned_stack)
    }
  } else {
    if (befores.length > 0) {
      stack.concat(befores)
      befores = []
    }
    stack.concat(before_eachs)
    stack.push(item)
    stack.concat(after_eachs)
  }
  
  return this._build_session(befores, before_eachs, after_eachs, stack, ++index)
}


// (fn) -> undefined
//
// Params:
//  fn: The after function being added.
//
// Desc:
//  Add an after function that will be called once, after all tests.
proto.add_after = function (fn) {
  this.afters.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The after-each function being added.
//
// Desc:
//  Add an after each function that will be called after each test is called.
proto.add_after_each = function (fn) {
  this.after_eachs.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The before function being added.
//
// Desc:
//  Add a before function that will be called once, before all tests.
proto.add_before = function (fn) {
  this.befores.push(fn)
}

// (fn) -> undefined
//
// Params:
//  fn: The before each function being added.
//
// Desc:
//  Add a before-each function that will be called before each test.
proto.add_before_each = function (fn) {
  this.before_eachs.push(fn)
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

// (callback) -> undefined
//
// Params:
//  callback: The callback called when all tests have been completed.
//
// Desc:
//  Run all tests found in this suite, and any suites added to this suite.
proto.run = function (callback) {
  var self = this
}