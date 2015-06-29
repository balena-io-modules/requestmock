request = require 'request'

module.exports = -> 
	defaultHandler = request
	handlers = {}
	mock = (opts, cb) ->
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
	mock.register = (method, url, handler) ->
		if not handlers[url]?
			handlers[url] = {}
		handlers[url][method] = handler
	mock.deregister = (method, url) ->
		if not url?
			url = method
			handlers[url] = {}
		else
			delete handlers[url][method]
	mock.get = mock.register.bind(null, 'get')
	mock.post = mock.register.bind(null, 'post')
	mock.del = mock.register.bind(null, 'delete')
	mock.put = mock.register.bind(null, 'put')
	mock.patch = mock.register.bind(null, 'patch')
	mock.all = (url, handler) ->
		mock.get(url, handler)
		mock.post(url, handler)
		mock.del(url, handler)
		mock.put(url, handler)
	return mock
