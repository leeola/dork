#
# lib/suite.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
{Runner} = require './runner'
{Test} = require './test'



# Desc:
#   A Suite represents a collection of tests.
class Suite
  
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
    
    # The reporters this suite will report to.
    @_reporters = []
  
  # (callback, before_alls=[], before_eachs=[], after_eachs=[],
  #   index=0, report={}) -> undefined
  #
  # Params:
  #   callback: A function called when the entirty of the suite is done.
  #   before_alls: Optional. A list of before_alls to start with.
  #   before_eachs: Optional. A list of before_eachs to start with.
  #   after_eachs: Optional. A list of after_eachs to start with.
  #   index: Optional. The index of @_tests_and_suites this recursive
  #     iteration is currently at.
  #   report: Optional. The compiled report from any tests and suites ran.
  #
  # Desc:
  #   An internal function which iterates over @_tests_and_suites. It includes
  #   optional arguments for parental pre/post hooks as well.
  _run: (callback, before_alls=[], before_eachs=[], after_eachs=[], index=0,
        report={
          total_tests: 0
        }) =>
    
    # If we're at the start of the iterations, append @this's pre/post
    # hook runners to the supplied argument pre/post runners.
    if index is 0
      before_alls.push @_before_alls...
      before_eachs.push @_before_eachs...
      # Note that the after_each's need to be added to the *beginning*
      # of the list. This allows the following design..
      # Their Befores > Our Befores > Test < Our Afters < Their Afters
      after_eachs[...0] = @_after_eachs
    
    # Our test or suite
    item = @_tests_and_suites[index]
    
    # If item does not exist, callback
    if not item?
      # If we have one or more tests, run the after_all runners, and
      # then callback.
      if report.total_tests > 0
        @_run_runners @_after_alls, ->
          callback report
      else
        callback report
      return
    
    # Called after @_run_runners is finished iterating through befores.
    # Note that these are both `before_alls` and `before_eachs`
    befores_callback = (runner_reports) =>
      # Since we just ran before_alls, empty it if we need to.
      if before_alls.length > 0
        before_alls = []
      item.run test_callback
    
    # Called when our test is done.
    test_callback = (test_report) =>
      # We're just faking the report for now.
      report.total_tests += 1
      @_run_runners after_eachs, after_eachs_callback
    
    # Called after `@_run_runners` is finished iterating through `after_eachs`
    after_eachs_callback = (runner_reports) =>
      @_run callback, before_alls, before_eachs, after_eachs, ++index, report
    
    # Called when item is a suite, and `item._run` has finished.
    suite_callback = (suite_report) =>
      if suite_report.total_tests > 0
        before_alls = []
        report.total_tests += suite_report.total_tests
      @_run callback, before_alls, before_eachs, after_eachs, ++index, report
    
    if item instanceof Test
      befores = []
      befores.push before_alls...
      befores.push before_eachs...
      @_run_runners befores, befores_callback
    else
      item._run suite_callback, before_alls[..],
        before_eachs[..], after_eachs[..]
  
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
    @_tests_and_suites.push test
  
  # (callback) -> undefined
  #
  # Params:
  #   callback: The callback called when all tests have been completed.
  #
  # Desc:
  #   Run all the tests found in this suite, and any suites added to this.
  run: (callback=->) ->
    @_run (reports) ->
      callback reports



exports.create = (description, location) -> new Suite description, location
exports.Suite = Suite
