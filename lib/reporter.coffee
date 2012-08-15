#
# lib/reporter.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#




class Reporter
  constructor: (suite) ->
    suite.on 'test_start', @_test_start
    suite.on 'test_end', @_test_end
    suite.on 'suite_start', @_suite_start
    suite.on 'suite_end', @_suite_end
    suite.on 'complete', @_complete
  
  _complete: =>
  
  _test_start: =>
  
  _test_end: =>
  
  _suite_start: =>
  
  _suite_end: =>



class StdoutReporter extends Reporter
  constructor: (suite, options) ->
    super suite
  
  _complete: =>
    process.stdout.write 'Complete!\n'
  
  _test_start: =>
    process.stdout.write 'Test Started\n'
  
  _test_end: (data) =>
    process.stdout.write "Test Ended: \n"
  
  _suite_start: =>
    process.stdout.write 'Suite Started\n'
  
  _suite_end: =>
    process.stdout.write 'Suite Ended\n'




exports.Reporter = Reporter
exports.StdoutReporter = StdoutReporter