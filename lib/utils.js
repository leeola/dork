//
// lib/utils.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed
//
/*jshint asi: true, laxcomma: true*/


// (a, b) -> a + b
//
// Params:
//  a: The instance to be written on
//  b: The instance to write onto a
//
// Returns:
//  The returned object is `a` with the contents of `b` written ontop of it.
//  This is very unsafe, and it will most likely injur your dog.
//
// Desc:
//  A simple and unsafe merge of objects a and b. 
exports.merge = function (a, b) {
  for (var key in b)
    a[key] = b[key]
}