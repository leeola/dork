#
# lib/test.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
runner = require './runner'
utils = require './utils'



# (description, location) -> object
#
# Params:
#   desccription: The description of the test being created. Undefined is
#     allowed.
#   location: The location of the test being created. Undefined is allowed.
#   fn: The test function.
#   timeout: The timeout in ms before this function will fail.
#
# Returns:
#   A new instance of a test.
#
# Desc:
#   Create a test instance.
create = (description, location, fn, timeout) ->
  test = {}
  
  # Merge in the runner object, and initialize.
  #
  # Note this this method of creation/inheritance is going to be replaced
  # once i find a method that isn't ugly and is true to javascript.. if
  # that's even possible.
  utils.merge test, runner.proto
  test.init_runner = test.init
  
  utils.merge test, proto
  test.init description, location, fn, timeout
  
  return test

# The 'prototype' for our object.
proto = exports.proto = {}

# (description, location) -> object
#
# Params:
#   desccription: The description of the test being created. Undefined is
#     allowed.
#   location: The location of the test being created. Undefined is allowed.
#   fn: The test function.
#   timeout: The timeout in ms before this function will fail.
#
# Desc:
#   Initialize the data for this object instance.
proto.init = (description, location, fn, timeout) ->
  @init_runner fn, timeout
  
  @description = description
  @location = location



exports.create = create
