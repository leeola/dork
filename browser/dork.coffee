#
# browser/index.coffee
#
# Expose a dork namespace. Note that this actually exposes the browser-bin
# first, then the lib under that. So, `dork` translates to /bin/browser/bin,
# and `dork.lib` translates to /lib/index.
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
bin = require '../bin/browser/bin'
lib = require '../lib'




# Set up our exports.
exports = module.exports = bin
exports.lib = lib



# Now expose our exports to window, with safety checking.
if not window.dork?
  window.dork = exports
else
  throw new Error 'Namespace "dork" already taken in `window`. Dork failed '+
    'to load.'
