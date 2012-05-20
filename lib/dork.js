//
// lib/dork.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed 
//
/*jshint asi: true, laxcomma: true*/
var suite = require('./suite')
  , test = require('./test')
  , utils = require('./utils')


// () -> function
//
// Returns:
//  A new instance of.. a dork? I'm not sure what i should call this
//  stupidly named testing framework :s
//
// Desc:
//  Create a dork instance.
exports.create = function () {
  var dork = {}
  
  utils.merge(dork, proto)
  dork.init()
  return dork
}

// The 'prototype' for our object
var proto = exports.proto = {}

// () -> function
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function () {
  this.active_suite = suite.create()
}