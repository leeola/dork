#
# lib/reporter.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#




parse_error = (error) ->
  # Ignore the first line since it's just the name and message.
  stack = error.stack.split('\n    ')[1..]
  return error =
    name: error.name
    message: error.message
    stack: stack



class Reporter
  constructor: (suite) ->
    if suite?
      @listen suite
  
  _complete: =>
  
  _test_start: =>
  
  _test_end: =>
  
  _report: =>
  
  _suite_start: =>
  
  _suite_end: =>
  
  end: (suite) ->
    suite.remove 'test_start', @_test_start
    suite.remove 'test_end', @_test_end
    suite.remove 'report', @_report
    suite.remove 'suite_start', @_suite_start
    suite.remove 'suite_end', @_suite_end
    suite.remove 'complete', @_complete
  
  listen: (suite) ->
    suite.on 'test_start', @_test_start
    suite.on 'test_end', @_test_end
    suite.on 'report', @_report
    suite.on 'suite_start', @_suite_start
    suite.on 'suite_end', @_suite_end
    suite.on 'complete', @_complete
  
  report: (args...) -> @listen args...



class SimpleReporter extends Reporter
  constructor: (suite, options) ->
    super suite
    
    @_write = (args...) -> process.stdout.write args...
   
  _complete: (data) =>
    total_tests = data.tests.all.length
    total_passed = data.tests.passed.length
    total_failed = data.tests.failed.length
    
    if total_passed is total_tests
      @_write "#{total_tests} tests complete\n"
    else if (total_failed + total_passed) < total_tests
      # This is worded horribly lol. Needs to be improved.
      @_write "#{total_failed} failed of #{total_passed} run, "+
        "#{total_tests} possible\n"
    else
      @_write "#{total_failed} out of #{total_tests} failed.\n"
  
  _report: (report) =>
    if not report.success
      error = parse_error report.error
      @_write "#{report.id}) #{report.descriptions.join ' '}:\n"
      @_write "  #{error.name}: #{error.message}\n"
      @_write "    #{error.stack.join '\n    '}\n"




exports.Reporter = Reporter
exports.SimpleReporter = SimpleReporter
exports.StdoutReporter = SimpleReporter