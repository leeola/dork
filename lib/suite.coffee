#
# lib/suite.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
{Runner} = require './runner'



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
    @_befores = []
    @_before_eachs = []
    @_afters = []
    @_after_eachs = []
    
    # A list of suites and test runners.
    @_tests_and_suites = []
  
  # ([befores, before_eachs, after_eachs, [session, index]]) -> Array
  #
  # Params:
  #   befores: A list of before runners.
  #   before_eachs: A list of before_each runners.
  #   after_eachs: A list of after_each runners.
  #   session: Optional. A list containing the built session. This object is
  #     recursively modified and eventually returned.
  #   index: Optiona. The index of `@_tests_and_suites` to use.
  #
  # Returns:
  #   A list containing runnables. The runnavbles are in before/test/after
  #   order, containing all the tests found in any added suites, along with
  #   the before_eachs and after_eachs from each suite.
  #
  # Desc:
  #   Build a list of runnables which can be passed to `@_run_session()`.
  #   This is a recursive method.
  _build_session: (befores=[], before_eachs=[], after_eachs=[], session=[], index=0) ->
    # If we are on the first iteration, combine the given pre/post hooks
    # with this suite's pre/post hooks.
    if index is 0
      befores.push @_befores...
      before_eachs.push @_before_eachs...
      # Note that the after_each's need to be added to the *beginning*
      # of the list. This allows the following design..
      # Their Befires > Our Befores > Test < Our Afters < Their Afters
      after_eachs[...0] = @_after_eachs
    
    # The test/suite we're working on in this iteration.
    item = @_tests_and_suites[index]
    
    # If the item is undefined, we're at the end of the tests_and_suites,
    # so we'll want to return out of this iteration.
    if not item?
      # If we had at least one test in this suite, or any subsuites, then
      # we want to append our `@_afters` to the session.
      if session.length > 0
        session.push @_afters...
      return session
    
    if item instanceof Suite
      # The item is a Suite. Tell it to build it's own session, so we can
      # combine it with ours.
      item_session = item._build_session befores[..], before_eachs[..], after_eachs[..]
      
      if item_session.length > 0
        # If the item_session has any items in it, then it will have appended
        # our before's. Since these can only execute once, we want to set
        # it to a new list.
        befores = []
        # Now combine the sessions.
        session.push item_session...
    else
      # The item is a test.
      
      if befores.length > 0
        # Since this is a test, and we have befores, append the befores to
        # our session, so they're on the session before we add our test.
        session.push befores...
        befores = []
      
      # Append our item, wrapped in before_eachs and after_eachs
      session.push before_eachs...
      session.push item
      session.push after_eachs...
    
    # Return our iteration.
    return @_build_session befores, before_eachs, after_eachs,
      session, ++index
  
  # (runner) -> undefined
  #
  # Params:
  #   runner: A function or Runner.
  #
  # Desc:
  #   A runner to be called to be called after the last test.
  add_after: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_afters.push runner
  
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
  add_before: (runner) ->
    if runner instanceof Function
      runner = new Runner runner
    @_befores.push runner
  
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
  run: (callback) ->



exports.create = (description, location) -> new Suite description, location
exports.Suite = Suite
