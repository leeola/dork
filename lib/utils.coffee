#
# lib/reporter.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#




exports.index_of = exports.indexOf = (list, target) ->
  return i for v, i in list when v is target