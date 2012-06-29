#
# lib/test.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
utils = require("./utils")
exports.create = (fn, timeout) ->
  runner = {}
  utils.merge runner, proto
  runner.init fn, timeout
  runner

proto = exports.proto = {}
proto.init = (fn, timeout) ->
  timeout = 2000  if timeout is `undefined`
  @_fn = fn
  @_timeout = timeout
  @sync = (if fn isnt fn.length isnt 1 then true else false)  if fn isnt `undefined`

proto.run = (callback) ->
  self = this
  running = true
  start_time = undefined
  if @_fn is `undefined`
    callback
      description: @description
      success: true

    return `undefined`
  done = ->
    if running
      running = false
      callback
        description: @description
        success: true
        time: new Date() - start_time

  timeout_callback = ->
    if running
      running = false
      callback
        description: @description
        success: false
        time: new Date() - start_time

  try
    start_time = new Date()
    @_fn done
    setTimeout timeout_callback, @_timeout
  catch error
    running = false
    callback
      description: @description
      error: error
      stack: error.stack
      success: false
      time: new Date() - start_time

    return `undefined`
  done()  if @_fn.length is 0