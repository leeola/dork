//
// lib/index.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed 
//
/*jshint asi: true, laxcomma: true*/
var dork = require('./dork')


// Our cached instance of a dork test session.
var dork_session

if (dork_session === undefined) {
  dork_session = dork.create()
}

// Now assign the session as the root object to the library.
// This will allow `require('dork').describe()` usage, allowing for
// a simple and Mocha consistent-ish interface.
exports = module.exports = dork_session

exports.dork = dork
exports.suite = require('./suite')
exports.test = require('./test')