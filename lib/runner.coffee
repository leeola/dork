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
    
    # Our `@_fn` callback.
    done = =>
      if running
        running = false
        callback report =
          success: true
          time: new Date() - start_time
    
    # The timeout function
    timeout_callback = =>
      if running
        running = false
        callback report =
          success: false
          time: new Date() - start_time
    
    start_time = new Date()
    try
      @_fn done
    catch error
      running = false
      callback report =
        error: error
        stack: error.stack
        success: false
        time: new Date() - start_time
    
    # If the @_fn is synchronous, call done() since the code
    # already ran and finished.
    # Note that even if there is an error, done() will be called, but that
    # doesn't matter since done() checks for `running`.
    if @asynchronous
      setTimeout timeout_callback, @_timeout
    else
      done()



exports.create = (fn, timeout) -> return new Runner fn, timeout
exports.Runner = Runner
