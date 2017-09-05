request = require 'request'
_ = require 'lodash'

defaultHandler = request
logEnabled = false
fixedUrlHandlers = {}
regexHandlers = {}

## Request module methods

exports = module.exports = (opts, cb) ->
	if typeof opts is 'string'
		url = opts
	else
		url = opts.url ? opts.uri
	if url.indexOf('?') != -1
		url = url.slice(0, url.indexOf('?'))
	method = (opts.method ? 'get').toLowerCase()
	if logEnabled
		console.log('requestmock:', url, method, opts)

	# First look for an exact match, then scan for a matching regex handler.
	# If no matches are found, call the default handler
	if fixedUrlHandlers[url]?[method]?
		return fixedUrlHandlers[url][method](opts, cb)
	else
		for regexStr of regexHandlers
			regex = new RegExp(regexStr)
			if regex.test(url) and regexHandlers[regexStr][method]?
				return regexHandlers[regexStr][method](opts, cb)

	return defaultHandler(opts, cb)

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
