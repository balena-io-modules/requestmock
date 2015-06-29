mockery = require 'mockery'
{ expect } = require 'chai'
requestMock = require('../index')()

mockery.enable(warnOnUnregistered: false)
mockery.registerMock('request', requestMock)

request = require 'request'

describe 'requestMock', ->
	describe 'get', ->
		it 'should register mock module for get requests', ->
			requestMock.get 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 200 }, 'get mock')
			request 'http://google.com', (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(200)
				expect(body).to.equal('get mock')
	describe 'post', ->
		it 'should register mock module for POST requests', ->
			requestMock.post 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 201 }, 'post mock')
			request { url: 'http://google.com', method: 'POST' }, (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(201)
				expect(body).to.equal('post mock')
	describe 'put', ->
		it 'should register mock module for PUT requests', ->
			requestMock.put 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 202 }, 'put mock')
			request { url: 'http://google.com', method: 'PUT' }, (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(202)
				expect(body).to.equal('put mock')
	describe 'patch', ->
		it 'should register mock module for PATCH requests', ->
			requestMock.patch 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 203 }, 'patch mock')
			request { url: 'http://google.com', method: 'PATCH' }, (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(203)
				expect(body).to.equal('patch mock')
	describe 'del', ->
		it 'should register mock module for DELETE requests', ->
			requestMock.del 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 204 }, 'delete mock')
			request { url: 'http://google.com', method: 'DELETE' }, (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(204)
				expect(body).to.equal('delete mock')
	describe 'all', ->
		it 'should register mock module for any request', ->
			requestMock.all 'http://google.com', (opts, cb) ->
				cb(null, { statusCode: 205 }, 'all mock')
			request 'http://google.com', (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(205)
				expect(body).to.equal('all mock')
	describe 'deregister', ->
		it 'should allow deregistering mock handlers', ->
			requestMock.deregister('http://google.com')
			request 'http://google.com', (err, response, body) ->
				expect(response).to.have.property('statusCode').that.equals(200)
				expect(body[0..20]).to.not.contain('mock')
