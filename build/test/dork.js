//
// test/dork.js
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



describe('dork', function () {
  var dork_lib = require('../lib/dork')
  
  describe('#()', function () {
    var dork
    
    before_each(function () {
      dork = dork_lib.create()
    })
    
    it('should return a dork instance', function () {
      dork.should.be.an.instanceof(dork_lib.Dork)
    })
    
    it('should be a unique object each execution', function () {
      var new_test = dork_lib.create()
        , old_test = dork
      
      old_test.foo = 'bar'
      should.not.exist(new_test.foo)
    })
  })
})
