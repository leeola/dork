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
  
  # (callback) -> undefined
  _run: (callback, before_alls=[], before_eachs=[], after_eachs=[], index=0) =>
    
    if index is 0
      before_alls.push @_before_alls...
      before_eachs.push @_before_eachs...
      after_eachs.push @_after_eachs...
    
    item = @_tests_and_suites[index]
    
    if not item?
      @_run_runners @_after_alls, callback
      return
    
    before_alls_callback = (reports) ->
      before_alls = []
      item.run test_callback
    
    test_callback = (report) =>
      @_run_runners after_eachs, after_eachs_callback
    
    after_eachs_callback = (report) =>
      @_run callback, before_alls, before_eachs, after_eachs, ++index
    
    suite_callback = (reports) =>
      @_run callback, before_alls, before_eachs, after_eachs, ++index
    
    if item instanceof Test
      runners = []
      runners.push before_alls...
      runners.push before_eachs...
      @_run_runners runners, before_alls_callback
    else
      item._run suite_callback, before_alls[..],
        before_eachs[..], after_eachs[..]
  
  _run_runners: (runners, callback, index=0, reports=[]) =>
    runner = runners[index]
    
    if not runner?
      callback reports
      return
    
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
      callback()



exports.create = (description, location) -> new Suite description, location
exports.Suite = Suite
