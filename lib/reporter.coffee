#
# lib/reporter.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#



class Reporter
  constructor: (suite) ->
    suite.on 'pre', @_pre
    suite.on 'test_start', @_pre
    suite.on 'test_end', @_test_end
    suite.on 'suite', @_pre
    suite.on 'post', @_pre
  
  report: ->


class STDReporter extends Reporter



exports.Reporter = Reporter