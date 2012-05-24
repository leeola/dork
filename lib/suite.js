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
  this.tests_and_suites = []
  
  this.description = description
  this.location = location
}

// ([befores, before_eachs, after_eachs, [session, index]]) -> Array
//
// Params:
//  befores: An list of before runners.
//  before_eachs: A list of before_each runners.
//  after_each: A list of after_each runners.
//  session: Optional. A list containing the built session. This object is
//    recursively modified and eventually returned.
//  index: Optional. The index of `this.tests_and_suites` to use.
//
// Returns:
//  A list containing runnables. The runnables are in before/test/after order,
//  containing all the tests found in any added suites, along with the
//  before_eachs and after_eachs from each suite.
//
// Desc:
//  Build a list of runnables which can be passed to `self._run_session()`.
//  This is a *recursive* function.
proto._build_session = function (befores, before_eachs, after_eachs, session, index) {
  // Set up our default values if arguments are missing. Note that because
  // this function is private(ish) we don't worry about protecting the
  // user from every possible combination of invalid arguments.
  if(arguments.length === 0) {
    // No arguments given.
    
    befores = before_eachs = after_eachs = session = []
    index = 0
  } else if(session === undefined) {
    // Only befores/before_eachs/after_eachs were given.
    
    session = []
    index = 0
  }
  
  // If we are on the first iteration, combine the given pre/post hooks
  // with this suite's pre/post hooks.
  if (index === 0) {
    befores = befores.concat(this.befores)
    before_eachs = before_eachs.concat(this.before_eachs)
    // Note that the after_each's need to be added to the *beginning* of
    // the list. This allows for the following design..
    // Their Befores -> Our Befores -> Test <- Our Afters <- Their Afters
    after_eachs = this.after_eachs.concat(after_eachs)
  }
  
  // The test/suite we are working with on this iteration.
  var item = this.tests_and_suites[index]
  
  // If the item is undefined, we're at the end of the tests_and_suites,
  // so we'll want to return out of this iteration.
  if (item === undefined) {
    
    // If we had atleast one or more tests, in this suite or any subsuites,
    // we want to append our `this.afters`.
    if (session.length > 0) {
      session = session.concat(this.afters)
    }
    
    // Return our lovely hand crafted session.
    return session
  }
  
  if (item._build_session !== undefined) {
    // If item._build_session exists, the item is a suite. So make it
    // build it's own session, and combine it with ours.
    var item_session = item._build_session(befores, before_eachs, after_eachs, [], 0)
    
    if (item_session.length > 0) {
      // Set `befores = []` so that on any future tests, the befores are not
      // added.
      befores = []
      session = session.concat(item_session)
    }
  } else {
    // If it does not have the _build_session method, treat the item as a test
    
    // If we have any befores, append them onto the session.
    if (befores.length > 0) {
      session.concat(befores)
      // Set `befores = []` so that on any future tests, the befores are not
      // added.
      befores = []
    }
    
    // Append our item, wrapped in before_eachs & after_eachs
    session.concat(before_eachs)
    session.push(item)
    session.concat(after_eachs)
  }
  
  // Return our iteration.
  return this._build_session(befores, before_eachs, after_eachs, session, ++index)
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
  this.tests_and_suites.push(suite)
}

// (test) -> undefined
//
// Params:
//  test: The test being added.
//
// Desc:
//  Add a test to this suite.
proto.add_test = function (test) {
  this.tests_and_suites.push(test)
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