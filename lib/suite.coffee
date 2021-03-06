#
# lib/suite.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
emighter = require 'emighter'
utils = require './utils'
{Runner} = require './runner'
{Test} = require './test'




# Desc:
#   A Suite represents a collection of tests.
class Suite extends emighter.Emighter
  
  # (@description, @location) -> undefined
  #
  # Params:
  #   description: The description of this suite.
  #   location: The location of this suite.
  #
  # Desc:
  #   Initialize the instance variables.
  constructor: (@description, @location) ->
    # Lists of runners that will be executed before/after tests.
    @_before_alls = []
    @_before_eachs = []
    @_after_alls = []
    @_after_eachs = []
    
    # A list of suites and test runners.
    @_tests_and_suites = []
    
    @_session = undefined
    
    # Don't forget to call our super!
    super()
  
  _on_child_before_all: (meta, done) =>
    @_run_before_alls meta, -> done()
  
  _on_child_before_each: (meta, done) =>
    @_run_before_eachs meta, -> done()
  
  _on_child_after_each: (meta, done) =>
    @_run_after_eachs meta, -> done()
  
  _on_child_complete: (data, done) =>
    # Loop through the child-suites tests and push this suites
    # description onto them.
    for test in data.tests.all
      if @description?
        test.descriptions[0...0] = @description
      @_session.tests.all.push test
    
    @_session.tests.failed.push data.tests.failed...
    @_session.tests.passed.push data.tests.passed...
    @emit 'suite_end'
    @_next()
  
  _complete: () =>
    @_run_after_alls =>
      @emit 'complete',
        tests:
          all: @_session.tests.all
          failed: @_session.tests.failed
          passed: @_session.tests.passed
  
  _run_after_alls: (callback) =>
    if @_session.ran_a_test
      @_run_runners @_after_alls, =>
        @emit 'after_all', [], =>
          callback()
    else
      @emit 'after_all', [], =>
        callback()
  
  _run_after_eachs: (meta, callback) =>
    @_run_runners @_after_eachs, =>
      @emit 'after_each', [meta], =>
        callback()
  
  _run_before_alls: (meta, callback) =>
    @emit 'before_all', [meta], =>
      if not @_session.ran_a_test
        @_session.ran_a_test = true
        @_run_runners @_before_alls, =>
          callback()
      else
        callback()
  
  _run_before_eachs: (meta, callback) =>
    @emit 'before_each', [meta], =>
      @_run_runners @_before_eachs, =>
        callback()
  
  _run_test: (test, callback) =>
    # First increment the id index.
    @_session.id_index++
    
    # Next we need to process through all patterns to match for.
    if @_session.patterns.length > 0
      matched_pattern = false
      for pattern in @_session.patterns
        if pattern instanceof RegExp
          full_description = "#{@_session.descriptions.join ' '} "+
            "#{test._description}"
          if pattern.test full_description
            matched_pattern = true
            # Break out of the loop since we only care about one match
            break
        else
          # Everything else we assume is an integer, and test it against
          # the test id_index.
          if pattern is @_session.id_index
            matched_pattern = true
            # Break out of the loop since we only care about one match
            break
      
      # Now we check to make sure at least one of the patterns matched. If
      # none did, bail out of this test.
      if not matched_pattern
        callback()
        return
    
    # If we've passed the pattern check, go ahead and run all the tests.
    @_run_before_alls @_session.meta, =>
      @_run_before_eachs @_session.meta, =>
        @emit 'test_start'
        test.run (report) =>
          # Add some meta
          report.id = @_session.id_index
          report.descriptions = [@description, report.description]
          
          @_session.tests.all.push report
          if report.success
            @_session.tests.passed.push report
          else
            @_session.tests.failed.push report
          
          @emit 'test_end', report
          @_run_after_eachs @_session.meta, =>
            callback()
  
  _run_suite: (suite) =>
    # Note that due to a bug in coffeescript, we need to explicitly tell
    # emighter that we want to use a callback.
    # See: https://github.com/jashkenas/coffee-script/issues/2489
    suite.on 'before_all', @_on_child_before_all, callback: true
    suite.on 'before_each', @_on_child_before_each, callback: true
    suite.on 'after_each', @_on_child_after_each, callback: true
    suite.on 'complete', @_on_child_complete, callback: true
    
    # Now set up some forwarding for events.
    suite.on 'test', (args...) => @emit 'test', args...
    suite.on 'test_start', (args...) => @emit 'test_start', args...
    suite.on 'test_end', (args...) => @emit 'test_end', args...
    suite.on 'suite', (args...) => @emit 'suite', args...
    suite.on 'suite_start', (args...) => @emit 'suite_start', args...
    suite.on 'suite_end', (args...) => @emit 'suite_end', args...
    
    # And emit our own suite start!
    @emit 'suite_start'
    suite._run @_session.patterns, @_session.id_index, @_session.descriptions
  
  _next: =>
    @_session.item = @_tests_and_suites[++@_session.index]
    
    if not @_session.item?
      if @_session.test_reports > 0
        @_run_after_alls()
      else
        @_complete()
      
    else if @_session.item instanceof Suite
      @_run_suite @_session.item
      
    else
      @_run_test @_session.item, @_next
  
  _run: (patterns=[], id_index=0, descriptions=[], callback=->) =>
    # Copy the chain, so that we can push our description without modifying
    # the original.
    descriptions = descriptions[..]
    if @description?
      descriptions.push @description
    
    @_session =
      descriptions: descriptions
      ran_a_test: false
      index: -1
      id_index: 0
      tests:
        all: []
        failed: []
        passed: []
      patterns: patterns
      callback: callback
    @_next()
  
  # (runners, callback, index=0, reports=[]) -> undefined
  #
  # Params:
  #   runners: A list of runners to iterate over and execute.
  #   callback: The callback
  #   index: Optional. The recursive index.
  #   reports: Optional. The reports from each runner.
  #
  # Desc:
  #   An internal function to run a list of runners, and callback when
  #   complete.
  _run_runners: (runners, callback, index=0, reports=[]) =>
    runner = runners[index]
    # If the item is null, callback with our collective reports.
    if not runner?
      callback reports
      return
    
    # Run the runner!
    runner.run (report) =>
      reports.push report
      @_run_runners runners, callback, ++index, reports
  
  # (runner) -> undefined
  #
  # Params:
  #   runner: A function or Runner.
  #
  # Desc:
  #   A runner to be called to be called after the last test.
  add_after_all: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_after_alls.push runner
  
  # (runner) -> undefined
  #
  # Params:
  #   runner: A function or Runner.
  #
  # Desc:
  #   A runner to be called to be called after each test.
  add_after_each: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_after_eachs.push runner
  
  # (runner) -> undefined
  #
  # Params:
  #   runner: A function or Runner.
  #
  # Desc:
  #   A runner to be called to be called before the first test.
  add_before_all: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_before_alls.push runner
  
  # (runner) -> undefined
  #
  # Params:
  #   runner: A function or Runner.
  #
  # Desc:
  #   A runner to be called before each test.
  add_before_each: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_before_eachs.push runner
  
  # (reporters) -> undefined
  #
  # Params:
  #   reporter: The reporter to add.
  #
  # Desc:
  #   Add a suite to this suite.
  add_reporter: (reporter) ->
    @_reporters.push reporter
  
  # (suite) -> undefined
  #
  # Params:
  #   suite: The suite being added.
  #
  # Desc:
  #   Add a suite to this suite.
  add_suite: (suite) ->
    @_tests_and_suites.push suite
  
  # (test) -> undefined
  #
  # Params:
  #   test: The test being added.
  #
  # Desc:
  #   Add a test to this suite.
  add_test: (test) ->
    if test instanceof Function
      test = new Test test
    @_tests_and_suites.push test
  
  # ([patterns..], [callback]) -> undefined
  #
  # Params:
  #   pattern..: Optional. A pattern is a number, string, or regex pattern
  #     which will be matched against the tests to determine if they are
  #     run or not.
  #     - Number: If a number is used, that Test ID will be used.
  #     - String: If a string is used, it is converted to regex via
  #         a regex-like syntax.
  #     - Regex: If a regex object is used, it is matched against tests
  #         and if it matches, the test is used.
  #   callback: Optional. The callback called when all tests have been
  #     completed.
  #
  # Desc:
  #   Run all the tests found in this suite, and any suites added to this.
  run: (patterns..., callback) ->
    # If callback is not a function, push it back into args.
    if callback? and not (callback instanceof Function)
      patterns.push callback
    
    for pattern, i in patterns
      if typeof pattern is 'string'
        patterns[i] = utils.regex_like pattern
    
    @_run patterns, 0, [], (reports) ->
      callback reports



exports.create = (args...) -> new Suite args...
exports.Suite = Suite
