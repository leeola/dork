//
// lib/runner.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/
var utils = require('./utils')


// () -> object
//
// Returns:
//  A new instance of a runner.
//
// Desc:
//  Create a runner instance.
exports.create = function () {
  var runner = {}
  
  utils.merge(runner, proto)
  runner.init()
  return runner
}

// The 'prototype' for our object
var proto = exports.proto = {}

// () -> undefined
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function () {
}