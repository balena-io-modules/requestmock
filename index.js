// Generated by CoffeeScript 1.12.4
(function() {
  var _, defaultHandler, deregister, exports, fixedUrlHandlers, logEnabled, regexHandlers, register, request;

  request = require('request');

  _ = require('lodash');

  defaultHandler = request;

  logEnabled = false;

  fixedUrlHandlers = {};

  regexHandlers = {};

  exports = module.exports = function(opts, cb) {
    var method, ref, ref1, ref2, regex, regexStr, url;
    if (typeof opts === 'string') {
      url = opts;
    } else {
      url = (ref = opts.url) != null ? ref : opts.uri;
    }
    if (url.indexOf('?') !== -1) {
      url = url.slice(0, url.indexOf('?'));
    }
    method = ((ref1 = opts.method) != null ? ref1 : 'get').toLowerCase();
    if (logEnabled) {
      console.log('requestmock:', url, method, opts);
    }
    if (((ref2 = fixedUrlHandlers[url]) != null ? ref2[method] : void 0) != null) {
      return fixedUrlHandlers[url][method](opts, cb);
    } else {
      for (regexStr in regexHandlers) {
        regex = new RegExp(regexStr);
        if (regex.test(url) && (regexHandlers[regexStr][method] != null)) {
          return regexHandlers[regexStr][method](opts, cb);
        }
      }
    }
    return defaultHandler(opts, cb);
  };

  exports.defaults = function() {
    return exports;
  };

  exports.get = function(opts, cb) {
    opts.method = 'GET';
    return exports(opts, cb);
  };

  exports.post = function(opts, cb) {
    opts.method = 'POST';
    return exports(opts, cb);
  };

  exports.head = function(opts, cb) {
    opts.method = 'HEAD';
    return exports(opts, cb);
  };

  exports.put = function(opts, cb) {
    opts.method = 'PUT';
    return exports(opts, cb);
  };

  exports.patch = function(opts, cb) {
    opts.method = 'PATCH';
    return exports(opts, cb);
  };

  exports.del = function(opts, cb) {
    opts.method = 'DELETE';
    return exports(opts, cb);
  };


  /**
  	 * @summary Register handler for method and url
  	 * @name register
  	 * @function
  	 *
  	 * @param {String|} method - HTTP method
  	 * @param {String|RegExp Object} - url to mock
  	 * @param {handler} - Handler function that will be called for this mocked url
  	 * @throws TypeError
   */

  exports.register = register = function(method, url, handler) {
    var handlers;
    method = method.toLowerCase();
    if (typeof url === 'string') {
      handlers = fixedUrlHandlers;
    } else if (_.isRegExp(url)) {
      url = url.source;
      handlers = regexHandlers;
    } else {
      throw new TypeError('url must be either a String or a RegExp object');
    }
    if (handlers[url] == null) {
      handlers[url] = {};
    }
    return handlers[url][method] = handler;
  };

  exports.deregister = deregister = function(method, url) {
    var handlers;
    if (url == null) {
      url = method;
      method = null;
    }
    if (_.isRegExp(url)) {
      url = url.source;
      handlers = regexHandlers;
    } else {
      handlers = fixedUrlHandlers;
    }
    if (method == null) {
      return handlers[url] = {};
    } else {
      method = method.toLowerCase();
      return delete handlers[url][method];
    }
  };

  exports.log = function(enabled) {
    return logEnabled = enabled;
  };

}).call(this);