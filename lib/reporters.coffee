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
  
  
  _complete: (report) =>
    total_failed = report.test_count.failed
    total_passed = report.test_count.passed
    total_skipped = report.test_count.skipped
    total_tests = report.test_count.total
    
    if total_passed is total_tests
      print_string = "#{total_tests} complete"
      if total_skipped > 0
        print_string += " and #{total_skipped} skipped"
      print_string += '\n'
      @_write print_string
    else
      print_string = "#{total_failed} out of #{total_tests} failed"
      
      if total_skipped > 0
        print_string += " and #{total_skipped} skipped"
      print_string += '\n'
      
      @_write print_string
  
  
  _report: (report) =>
    if not report.success
      switch report.type
        when 'test'
          error = parse_error report.error
          @_write "#{report.id}) #{report.descriptions.join ' '}:\n"
          @_write "  #{error.name}: #{error.message}\n"
          @_write "    #{error.stack.join '\n    '}\n"
        when 'after_all', 'after_each', 'before_all', 'before_each'
          error = parse_error report.error
          @_write "#{report.type}) #{report.descriptions.join ' '}:\n"
          @_write "  #{error.name}: #{error.message}\n"
          @_write "    #{error.stack.join '\n    '}\n"




exports.Reporter = Reporter
exports.SimpleReporter = SimpleReporter
exports.StdoutReporter = SimpleReporter