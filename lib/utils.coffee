#
# lib/reporter.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#




exports.index_of = exports.indexOf = (list, target) ->
  return i for v, i in list when v is target


# (regexy) -> new RegExp()
#
# Params:
#   string: A string that will be converted to Regex based on varying
#     rules.
#
# Desc:
#   Convert a regex-like string to a regex object, based on the following
#   rules..
#   
#   1) Implicit starting and ending values.
#   2) `*` is converted to any alpha-numeric-whitespace character.
#
exports.regex_like = (regexy) ->
  # Toss the pre-post operators on the string.
  regexy = "^#{regexy}$"
  # Replace * with a wildcard.
  regexy = regexy.replace(/\*/g, '.*')
  return new RegExp regexy