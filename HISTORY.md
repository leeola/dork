
0.0.6 /
==================

  * Added a flag to specify which dork installation to use when running tests.
    Note that this feature is.. hacky.. at best, a revision would be nice
    but as of yet, i cannot find another way to implement it due to how dork
    stores its session in the `require 'dork'` index file.
  * Fixed the index issue with subsuites not incrementing properly.
  * Added proper suite handling for a before/after failure. The suite itself
    now fails, and parent suites will not continue either.
  * Added async error catching support. This is currently Nodejs only,
    browser support will come with the browser focused version.

0.0.5 / 2012-08-24
==================

  * Added a fix for CoffeeScript testing so that it will import from
    directories relative to the specified testing file.

0.0.4 / 2012-08-23
==================

  * Fixed a global installation bug where the local Dork session was not
    being used, and as such making global bin usage impossible.
  * Added implicit/explicit CoffeeScript support to the Dork bin.

0.0.3 / 2012-08-22
==================

  * Rewrote `bin/dork.js` to remove some assumed hidden characters that were
    screwing with Linux installations.

0.0.2 / 2012-08-22
==================

  * Removed the wildcard for the Emighter dependancy. This was causing issues
    with Emighter's circular dependancy.

0.0.1 / 2012-08-22
==================

  * Initial release