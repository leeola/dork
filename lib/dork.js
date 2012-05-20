//
// lib/dork.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed 
//
/*jshint asi: true, laxcomma: true*/



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
  
  utils.merge(suite, proto)
  dork.init()
  return suite
}

// The 'prototype' for our object
var proto = exports.proto = {}

// () -> function
//
// Desc:
//  Initialize the data for this object instance.
proto.init = function () {
}