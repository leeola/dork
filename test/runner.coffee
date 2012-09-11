#
# test/runner.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
dork = require 'dork'
should = require 'should'
require './options'




describe 'runner', ->
  runner_lib = require '../lib/runner'
  # The tolerance we're using to assert correct execution times, in ms.
  time_tolerance = 60
  
  describe 'create()', ->
    runner = null
    
    before_each ->
      runner = runner_lib.create ->
    
    it 'should return a runner object instance', ->
      runner.should.be.an.instanceof runner_lib.Runner
    
    it 'should be a unique object each execution', ->
      new_runner = runner_lib.create()
      old_runner = runner
      
      old_runner.foo = 'bar'
      should.not.exist new_runner.foo
  
  describe '#run()', ->
    runner = null
    
    describe 'No fn,', ->
      before_each ->
        runner = runner_lib.create()
      
      it 'should callback immediately', ->
        called = false
        runner.run -> called = true
        called.should.be.true
    
    describe 'Sync fn,', ->
      before_each ->
        runner = runner_lib.create ->
      
      it 'should call back immediately', ->
        called = false
        runner.run -> called = true
        called.should.be.true
    
    describe 'Async fn,', ->
      
      before_each ->
        runner = runner_lib.create (done) ->
          setTimeout done, 100
      
      # These next two tests basically test the same thing in
      # two mildly different ways.
      it 'should not callback immediately', ->
        sync = false
        runner.run -> sync = true
        sync.should.be.false
      
      it 'should callback async-ish', (done) ->
        async = false
        runner.run ->
          async.should.be.true
          done()
        
        async = true
    
    describe 'Async timeout,', ->
      
      before_each ->
        runner = runner_lib.create ((done) -> setTimeout done, 500), 200
      
      it 'should timeout if execution time exceeds timeout', (done) ->
        runner.run (report) ->
          report.success.should.be.false
          report.time.should.be.within(
            200 - time_tolerance,
            200 + time_tolerance
          )
          done()
    
    describe 'Time measurements,', ->
      
      describe '100ms,', ->
        before_each ->
          runner = runner_lib.create (done) ->
            setTimeout done, 100
        
        it 'should callback with a time within tolerance', (done) ->
          runner.run (report) ->
            report.time.should.be.within(
              100 - time_tolerance,
              100 + time_tolerance
            )
            done()
      
      describe '300ms,', ->
        before_each ->
          runner = runner_lib.create (done) ->
            setTimeout done, 300
        
        it 'should callback with a time within tolerance', (done) ->
          runner.run (report) ->
            report.time.should.be.within(
              300 - time_tolerance,
              300 + time_tolerance
            )
            done()
      
      describe '500ms,', ->
        before_each ->
          runner = runner_lib.create (done) ->
            setTimeout done, 500
        
        it 'should callback with a time within tolerance', (done) ->
          runner.run (report) ->
            report.time.should.be.within(
              500 - time_tolerance,
              500 + time_tolerance
            )
            done()




if require.main is module then dork.run()