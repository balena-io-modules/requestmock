requestmock
-----------

[![npm version](https://badge.fury.io/js/requestmock.svg)](http://npmjs.org/package/requestmock)
[![dependencies](https://david-dm.org/resin-io/requestmock.png)](https://david-dm.org/resin-io/requestmock.png)

Mock calls to [request](https://www.npmjs.com/package/request) module.

Installation
------------

```sh
$ npm install requestmock
```

Using with mockery
------------------

```js
requestMock = require 'requestmock';
mockery = require 'mockery';

mockery.enable({warnOnUnregistered: false});
mockery.registerMock('request', requestMock);

// make sure request is required after mockery is set up.
request = require 'request';

requestMock.register('get', 'http://google.com', function (opts, cb) {
	cb(null, { statusCode: 200 }, 'get mock');
});
request('http://google.com', function (err, response, body) {
	console.log(body == 'get mock');
});
```

Documentation
-------------

* requestmock(opts, cb)

The module exports a function that can be used in the same way as the [request](http://github.com/request/request) module.

By default, it forwards all calls to the request module. Otherwise, you can use the module's functions to register or deregister handlers
based on url and method.

This is meant to be used in conjunction with [mockery](https://www.npmjs.com/package/mockery), to allow some http requests to be mocked
and others to be executed normally, during testing.

* .register(method, url, handler)

Setup a handler for a url. The handler will take two parameters, opts and callback, which are the same that were passed to the request module. The url can be either a string (representing an exact url) or a RegExp.

The handler should call the callback function passing an error object (null if success), a response-like object, and a string (http body).

The response-like object should define the properties as needed by your modules, typically at least the statusCode property.

* .deregister([ method ], url)

Remove handler for given method and url. If method is omitted, all handlers are removed.

* .log(enabled)

Enable or disable logging of all requests. Useful for inspecting all the outgoing requests of an application.

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/requestmock/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ npm install && npm test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/requestmock/issues](https://github.com/resin-io/requestmock/issues)
- Source Code: [github.com/resin-io/requestmock](https://github.com/resin-io/requestmock)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning.

License
-------

The project is licensed under the MIT license.
