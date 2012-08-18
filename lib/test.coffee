#
# lib/test.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
{Runner} = require './runner'




# Desc:
#   A Test is an extended Runner, providing information about the Runner
#   such as Description and Location.
#
#   In pracitce, a Test is often created by `it()` and a Runner is often
#   created by `before()` and etc.
class Test extends Runner
  # (@_description, @_location, @_fn, @_timeout) -> undefined
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
  constructor: (@_description, @_location, @_fn, @_timeout) ->
    if @_description instanceof Function
      @_fn = @_description
      @_timeout = @_location
      @_description = ''
      @_location = ''
    else if @_location instanceof Function
      @_timeout = @_fn
      @_fn = @_location
      @_location = ''
    super @_fn, @_timeout
  
  _create_report: (args...) ->
    report = super args...
    report.description = @_description
    return report




exports.create = (description, location, fn, timeout) ->
  new Test description, location, fn, timeout
exports.Test = Test
