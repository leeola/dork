//
// lib/test.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var utils = require('./utils')


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

// (callback) -> report
//
// Params:
//  callback: A callback which will called upon completion of this test. It will
//  be given a report object filled with information from the test.
//
// Desc:
//  Run this test.
proto.run = function (callback) {
  var self = this
  
  if (this.fn === undefined)
    return undefined
  
  var done = function () {
    callback({
        'description': this.description
      , 'success': true
    })
  }
  
  try {
    this.fn(done)
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