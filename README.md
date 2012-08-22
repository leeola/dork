
# Dork.js - Yet another test framework.

## Description

Dork.js is yet another testing framework. What sets it apart? Nothing. As time
goes on there will be some interesting features that set it apart, but for now
you'll be much better off with
[Mocha](http://visionmedia.github.com/mocha/)/etc.

## Installation

via npm:

```bash
npm install dork
```

## Examples

Dork.js follows the basic BDD pattern common among many Node testing
frameworks.

```CoffeeScript
dork = require 'dork'
should = require 'should'

dork.describe 'description', ->
  dork.before_each ->
    console.log 'I just spam before each test.'
  
  dork.it 'should pass', ->
    'foo'.should.equal 'foo'
  
  dork.it 'should eek', ->
    (-> throw new Error 'eek').should.throwError /eek/
  
  dork.it 'will timeout', (done) ->
    setTimeout (-> done()), 3000

dork.run()
```

Options are also available:

```CoffeeScript
dork.options
  global: true
  reporters: [new NotUglyReporter(), new LoggerReporter()]
```

And if you prefer less magic, a feature-complete API is available as well.

```CoffeeScript
should = require 'should'
dork = require 'dork'

{Suite} = dork.suite
{Test} = dork.test

suite = new Suite 'description'

suite.before_each ->
  console.log 'I just spam before each test.'

suite.add_test new Test 'should pass', ->
  'foo'.should.equal 'foo'

suite.add_test new Test 'should eek', ->
  (-> throw new Error 'eek').should.throwError /eek/

suite.add_test new Test 'will timeout', (done) ->
  setTimeout (-> done()), 3000

suite.run()
```

Dork is also available from the command line, via the `dork` command.

```bash
[leeolayvar@work]:/workspace/repo$ dork --help

Usage: dork [patterns]... [options]
patterns     A series of patterns to filter tests by. For additional help, see README.md#patterns
Options:
   -f FILE, --files FILE   The file or directory to run tests in.
Start dork tests in the given file or directory with optional overriding options.
```

which allows you to run any specific dork test file you like, and offers handy
access to pattern matching..

Pattern matching allows you to specify a specific set of tests to run via
explicitly stating the numeric test index, or a regex-like string that
will match tests before they run.

```bash
[leeolayvar@work]:/workspace/repo$ dork 1 # Run test 1

[leeolayvar@work]:/workspace/repo$ dork 1 2 # Run test 1 and 2

[leeolayvar@work]:/workspace/repo$ dork 1 2 *database* # Run test 1, 2, and any tests matching
  # the pattern `/^.*database.*$/`
```

And that's roughly it! Stay tuned for more interesting features :)

## Author

  - Lee Olayvar &lt;leeolayvar@gmail.com&gt;

## License

The MIT License (MIT)

Copyright (C) 2012 Lee Olayvar &lt;leeolayvar@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.