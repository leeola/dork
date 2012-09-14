#
# test/index.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
dork = require 'dork'
should = require 'should'
require './options'



describe 'index', ->
  
  it 'should return a dork instance', ->
    index = require '../lib'
    Dork = (require '../lib/dork').Dork
    
    index.should.be.an.instanceof Dork
  
  it 'should expose the inner library modules', ->
    index = require '../lib'
    
    should.exist index.dork
    should.exist index.suite
    should.exist index.test
    should.exist index.utils
  
  it 'should return the same object on each require', ->
    index_a = require '../lib'
    index_b = require '../lib'
    index_a.foo = 'foo'
    
    # This foo test isn't really needed, but i like it anyway..
    index_a.foo.should.equal 'foo'
    
    index_a.should.equal index_b




# Import the other tests.
require './runner'
require './test'
require './suite'
require './dork'
if require.main is module then dork.run()