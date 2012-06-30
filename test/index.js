//
// test/index.js
//
// Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
// MIT Licensed 
//
/*jshint asi: true, laxcomma: true*/
var should = require('should')



// These are here so my IDE will shut the hell up.
var before = global.before
  , before_each = global.beforeEach
  , describe = global.describe
  , it = global.it



describe('index', function () {
  
  it('should return a dork instance', function () {
    var index = require('../lib')
    
    // To assert it's identity we're just going to make sure
    // some basic dork vars exist.
    should.exist(index.active_suite)
    // And since the dork object is not that unique, lets make sure it's
    // not a suite/test object.
    should.not.exist(index.add_suite)
    should.not.exist(index.add_test)
    should.not.exist(index.fn)
  })
  
  it('should expose the inner library modules', function () {
    var index = require('../lib')
    
    should.exist(index.dork)
    should.exist(index.suite)
    should.exist(index.test)
    should.exist(index.utils)
  })
  
  it('should return the same object on each require', function () {
    var index_a = require('../lib')
    var index_b = require('../lib')
    index_a.foo = 'foo'
    
    // This foo test isn't really needed, but i like it anyway..
    index_a.foo.should.equal(index_b.foo)
    index_a.should.equal(index_b)
  })
})



require('./runner')
require('./test')

require('./suite')

require('./dork')