request = require 'request'

defaultHandler = request
logEnabled = false
handlers = {}

## Request module methods

exports = module.exports = (opts, cb) ->
	if typeof opts is 'string'
		url = opts
	else
		url = opts.url ? opts.uri
	if url.indexOf('?') != -1
		url = url.slice(0, opts.url.indexOf('?'))
	method = (opts.method ? 'get').toLowerCase()
	if logEnabled
		console.log('requestmock:', url, method, opts)
	if handlers[url]?[method]?
		return handlers[url][method](opts, cb)
	else
		return defaultHandler(opts, cb)

exports.defaults = ->
	return exports

exports.get = (opts, cb) ->
	opts.method = 'GET'
	exports(opts, cb)

exports.post = (opts, cb) ->
	opts.method = 'POST'
	exports(opts, cb)

exports.head = (opts, head) ->
	opts.method = 'HEAD'
	exports(opts, cb)

exports.put = (opts, head) ->
	opts.method = 'PUT'
	exports(opts, cb)

exports.patch = (opts, head) ->
	opts.method = 'PATCH'
	exports(opts, cb)

exports.del = (opts, del) ->
	opts.method = 'DELETE'
	exports(opts, cb)

## Request mock handling methods

exports.register = register = (method, url, handler) ->
	if not handlers[url]?
		handlers[url] = {}
	handlers[url][method] = handler

exports.deregister = deregister = (method, url) ->
	if not url?
		url = method
		handlers[url] = {}
	else
		delete handlers[url][method]

exports.log = (enabled) ->
	logEnabled = enabled
