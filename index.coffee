request = require 'request'

defaultHandler = request
handlers = {}

exports = module.exports = (opts, cb) ->
	if typeof opts is 'string'
		url = opts
	else
		url = opts.url
	if url.indexOf('?') != -1
		url = url.slice(0, opts.url.indexOf('?'))
	method = (opts.method ? 'get').toLowerCase()
	if handlers[url]?[method]?
		return handlers[url][method](opts, cb)
	else
		return defaultHandler(opts, cb)

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

exports.get = get = register.bind(null, 'get')
exports.post = post = register.bind(null, 'post')
exports.del = del = register.bind(null, 'delete')
exports.put = put = register.bind(null, 'put')
exports.patch = patch = register.bind(null, 'patch')

exports.all = (url, handler) ->
	get(url, handler)
	post(url, handler)
	del(url, handler)
	put(url, handler)
	patch(url, handler)
