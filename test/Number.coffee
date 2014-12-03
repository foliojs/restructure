{uint8, uint16, uint24, uint32, int8, int16, int24, int32, float, double, fixed32, fixed16, DecodeStream, EncodeStream} = require '../'
should = require('chai').should()
concat = require 'concat-stream'

describe 'Number', ->
  describe 'uint8', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xab, 0xff]
      uint8.decode(stream).should.equal 0xab
      uint8.decode(stream).should.equal 0xff

    it 'should have a size', ->
      uint8.size().should.equal 1

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xab, 0xff]
        done()

      uint8.encode(stream, 0xab)
      uint8.encode(stream, 0xff)
      stream.end()

  describe 'uint16', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xab, 0xff]
      uint16.decode(stream).should.equal 0xabff

    it 'should have a size', ->
      uint16.size().should.equal 2

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xab, 0xff]
        done()

      uint16.encode(stream, 0xabff)
      stream.end()

  describe 'uint24', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xff, 0xab, 0x24]
      uint24.decode(stream).should.equal 0xffab24

    it 'should have a size', ->
      uint24.size().should.equal 3

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xff, 0xab, 0x24]
        done()

      uint24.encode(stream, 0xffab24)
      stream.end()

  describe 'uint32', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xff, 0xab, 0x24, 0xbf]
      uint32.decode(stream).should.equal 0xffab24bf

    it 'should have a size', ->
      uint32.size().should.equal 4

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xff, 0xab, 0x24, 0xbf]
        done()

      uint32.encode(stream, 0xffab24bf)
      stream.end()

  describe 'int8', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0x7f, 0xff]
      int8.decode(stream).should.equal 127
      int8.decode(stream).should.equal -1

    it 'should have a size', ->
      int8.size().should.equal 1

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0x7f, 0xff]
        done()

      int8.encode(stream, 127)
      int8.encode(stream, -1)
      stream.end()

  describe 'int16', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xff, 0xab]
      int16.decode(stream).should.equal -85

    it 'should have a size', ->
      int16.size().should.equal 2

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xff, 0xab]
        done()

      int16.encode(stream, -85)
      stream.end()

  describe 'int24', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xff, 0xab, 0x24]
      int24.decode(stream).should.equal -21724

    it 'should have a size', ->
      int24.size().should.equal 3

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xff, 0xab, 0x24]
        done()

      int24.encode(stream, -21724)
      stream.end()

  describe 'int32', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0xff, 0xab, 0x24, 0xbf]
      int32.decode(stream).should.equal -5561153

    it 'should have a size', ->
      int32.size().should.equal 4

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0xff, 0xab, 0x24, 0xbf]
        done()

      int32.encode(stream, -5561153)
      stream.end()

  describe 'float', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0x43, 0x7a, 0x8c, 0xcd]
      float.decode(stream).should.be.closeTo 250.55, 0.005

    it 'should have a size', ->
      float.size().should.equal 4

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0x43, 0x7a, 0x8c, 0xcd]
        done()

      float.encode(stream, 250.55)
      stream.end()

  describe 'double', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0x40, 0x93, 0x4a, 0x3d, 0x70, 0xa3, 0xd7, 0x0a]
      double.decode(stream).should.be.equal 1234.56

    it 'should have a size', ->
      double.size().should.equal 8

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0x40, 0x93, 0x4a, 0x3d, 0x70, 0xa3, 0xd7, 0x0a]
        done()

      double.encode(stream, 1234.56)
      stream.end()

  describe 'fixed16', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0x19, 0x57]
      fixed16.decode(stream).should.be.closeTo 25.34, 0.005

    it 'should have a size', ->
      fixed16.size().should.equal 2

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0x19, 0x57]
        done()

      fixed16.encode(stream, 25.34)
      stream.end()

  describe 'fixed32', ->
    it 'should decode', ->
      stream = new DecodeStream new Buffer [0x00, 0xfa, 0x8c, 0xcc]
      fixed32.decode(stream).should.be.closeTo 250.55, 0.005

    it 'should have a size', ->
      fixed32.size().should.equal 4

    it 'should encode', (done) ->
      stream = new EncodeStream
      stream.pipe concat (buf) ->
        buf.should.deep.equal new Buffer [0x00, 0xfa, 0x8c, 0xcc]
        done()

      fixed32.encode(stream, 250.55)
      stream.end()
