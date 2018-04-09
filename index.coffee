request = require 'request'
_ = require 'lodash'

defaultHandler = request
logEnabled = false
fixedUrlHandlers = {}
regexHandlers = {}

config = {
	# Using requestMock with request-promise, requires you to either rely on
	# the global Promise library or specify a Promise library explicitly as
	# shown below:
	#
	#		requestMock = require('requestmock')
	#		requestMock.configure(Promise: require('some-promise-library'))
	Promise: (resolver) ->
		if global.Promise?
			console.warn('requestmock: No Promise library specified -- using native.')
			return new Promise(resolver)
		else
			throw new Error(
				'requestmock: No Promise library specified or available -- use ' +
				'`requestMock.configure()` to specify a Promise library.')
}

invoke = (handler, opts, cb) ->
	fn = (callback) -> handler(opts, callback)

	return if cb then fn(cb) else config.Promise (resolve, reject) ->
		resolver = (err, args...) ->
			resolver.invoked = true
			if err?
				reject(err)
			else
				resolve(if args.length > 1 then args else args[0])
		resolver.invoked = false

		try
			maybePromise = fn(resolver)
			if typeof maybePromise isnt 'undefined' and not resolver.invoked
				resolver(null, maybePromise)
		catch e
			resolver(e)

## Request module methods

exports = module.exports = (opts, cb) ->
	params = request.initParams(opts, cb)
	{ method, uri, url, callback } = params

	# Request will use `url` if `uri` isn't provided
	uri ?= url

	if _.includes(uri, '?')
		uri = uri.slice(0, uri.indexOf('?'))

	if logEnabled
		console.log('requestmock:', uri, method, opts)

	# First look for an exact match, then scan for a matching regex handler.
	# If no matches are found, call the default handler
	if fixedUrlHandlers[uri]?[method]?
		return invoke(fixedUrlHandlers[uri][method], opts, callback)
	else
		for regexStr of regexHandlers
			regex = new RegExp(regexStr)
			if regex.test(uri) and regexHandlers[regexStr][method]?
				return invoke(regexHandlers[regexStr][method], opts, callback)

	return invoke(defaultHandler, opts, callback)

# request-promise-core used by request-promise requires this being around.
exports.Request = request.Request

exports.configure = ({ Promise }) ->
	config.Promise = (resolver) ->
		return new Promise(resolver)

exports.defaults = ->
	return exports

exports.get = (opts, cb) ->
	opts.method = 'GET'
	exports(opts, cb)

exports.post = (opts, cb) ->
	opts.method = 'POST'
	exports(opts, cb)

exports.head = (opts, cb) ->
	opts.method = 'HEAD'
	exports(opts, cb)

exports.put = (opts, cb) ->
	opts.method = 'PUT'
	exports(opts, cb)

exports.patch = (opts, cb) ->
	opts.method = 'PATCH'
	exports(opts, cb)

exports.del = (opts, cb) ->
	opts.method = 'DELETE'
	exports(opts, cb)

## Request mock handling methods

###*
	# @summary Register handler for method and url
	# @name register
	# @function
	#
	# @param {String|} method - HTTP method
	# @param {String|RegExp Object} - url to mock
	# @param {handler} - Handler function that will be called for this mocked url
	# @throws TypeError
###
exports.register = register = (method, url, handler) ->
	method = method.toLowerCase()

	if typeof url is 'string'
		handlers = fixedUrlHandlers
	else if _.isRegExp(url)
		url = url.source
		handlers = regexHandlers
	else
		throw new TypeError('url must be either a String or a RegExp object')

	handlers[url] ?= {}
	handlers[url][method] = handler

exports.deregister = deregister = (method, url) ->
	if not url?
		url = method
		method = null

	if _.isRegExp(url)
		url = url.source
		handlers = regexHandlers
	else
		handlers = fixedUrlHandlers

	if not method?
		handlers[url] = {}
	else
		method = method.toLowerCase()
		delete handlers[url][method]

exports.log = (enabled) ->
	logEnabled = enabled
