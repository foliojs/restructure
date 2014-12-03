{Buffer:BufferT, DecodeStream, EncodeStream} = require '../'
should = require('chai').should()
concat = require 'concat-stream'

describe 'Buffer', ->
  it 'should decode', ->
    stream = new DecodeStream new Buffer [0xab, 0xff, 0x1f, 0xb6]
    buf = new BufferT(2)
    buf.decode(stream).should.deep.equal new Buffer [0xab, 0xff]
    buf.decode(stream).should.deep.equal new Buffer [0x1f, 0xb6]

  it 'should decode with parent key length', ->
    stream = new DecodeStream new Buffer [0xab, 0xff, 0x1f, 0xb6]
    buf = new BufferT('len')
    buf.decode(stream, len: 3).should.deep.equal new Buffer [0xab, 0xff, 0x1f]
    buf.decode(stream, len: 1).should.deep.equal new Buffer [0xb6]

  it 'should encode', (done) ->
    stream = new EncodeStream
    stream.pipe concat (buf) ->
      buf.should.deep.equal new Buffer [0xab, 0xff, 0x1f, 0xb6]
      done()

    buf = new BufferT(2)
    buf.encode stream, new Buffer [0xab, 0xff]
    buf.encode stream, new Buffer [0x1f, 0xb6]
    stream.end()

  it 'should return size', ->
    buf = new BufferT(2)
    buf.size(new Buffer [0xab, 0xff]).should.equal 2
