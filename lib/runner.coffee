#
# lib/test.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#



# Desc:
#   A runner is an object which encapsulates a function. When run, it will
#   run the function in a safe environment and report any failures. A simple
#   timeout feature is also included.
class Runner
  constructor: (@_fn=(->), @_timeout=2000) ->
    # An information var. If the function has defined the async 1st argument
    # callback, this will be true. Otherwise it will be false.
    if @_fn
      @asynchronous = if @_fn.length is 1 then true else false
  
  
  # (time, error) -> Object
  #
  # Params:
  #   time: The execution time of the function.
  #   error: Optional. If given, success is false.
  #
  # Desc:
  #   Create a Function report to pass back to functions. This method is
  #   inherited so that the output can be tailed to custom Runners (such
  #   as Tests).
  _create_report: (time, error) ->
    if error?
      report =
        error: error
        success: false
        time: time
    else
      report =
        success: true
        time: time
    return report
  
  # (callback) -> undefined
  #
  # Params:
  #   callback: A callback which will be called on completion of this @_fn
  #
  # Desc:
  #   Run this runner.
  run: (callback) =>
    running = true
    start_time = undefined
    timeout_error = undefined
    
    # Our `@_fn` callback.
    done = =>
      if running
        running = false
        process.removeListener 'uncaughtException', asynchronous_error
        callback @_create_report new Date() - start_time
    
    # The timeout function
    timeout_callback = =>
      if running
        running = false
        process.removeListener 'uncaughtException', asynchronous_error
        time = new Date() - start_time
        
        callback @_create_report time, timeout_error
    
    # Our async error callback.
    asynchronous_error = (error) =>
      if running
        running = false
        process.removeListener 'uncaughtException', asynchronous_error
        callback @_create_report new Date() - start_time, error
    
    # For now we're only supporting Nodejs. Browsers will likely be supported
    # via window.onerror.
    if @asynchronous
      #if not nodejs
      #  window.onerror = (message, url, line) ->
      #   #do stuff
      #else
      process.on 'uncaughtException', asynchronous_error
    
    start_time = new Date()
    try
      @_fn done
    catch error
      running = false
      callback @_create_report new Date() - start_time, error
    
    # If the @_fn is synchronous, call done() since the code
    # already ran and finished.
    # Note that even if there is an error, done() will be called, but that
    # doesn't matter since done() checks for `running`.
    if @asynchronous
      # We are generating an error here so that if we timeout, we aren't
      # trapped in the timeout context. I still need to figure out how to
      # navigate the JS stack to provide relevant results to the user.
      timeout_error = new Error "Execution time exceeded #{@_timeout}ms timeout"
      setTimeout timeout_callback, @_timeout
    else
      done()



exports.create = (fn, timeout) -> return new Runner fn, timeout
exports.Runner = Runner
