stream = require 'stream'
DecodeStream = require './DecodeStream'
iconv = require 'iconv-lite'

class EncodeStream extends stream.Readable
  constructor: ->
    super
    @pos = 0

  for key of Buffer.prototype when key.slice(0, 5) is 'write'
    do (key) =>
      bytes = DecodeStream.TYPES[key.replace(/write|[BL]E/g, '')]
      EncodeStream::[key] = (value) ->
        buffer = new Buffer +bytes
        buffer[key](value, 0)
        @writeBuffer buffer

  _read: ->
    # do nothing, required by node

  writeBuffer: (buffer) ->
    @push buffer
    @pos += buffer.length

  writeString: (string, encoding = 'ascii') ->
    switch encoding
      when 'utf16le', 'ucs2', 'utf8', 'ascii'
        @writeBuffer new Buffer(string, encoding)

      when 'utf16be'
        buf = new Buffer(string, 'utf16le')

        # swap the bytes
        for i in [0...buf.length - 1] by 2
          byte = buf[i]
          buf[i] = buf[i + 1]
          buf[i + 1] = byte

        @writeBuffer buf

      else
        @writeBuffer iconv.encode(string, encoding)

  writeUInt24BE: (val) ->
    buf = new Buffer(3)
    buf[0] = val >>> 16 & 0xff
    buf[1] = val >>> 8  & 0xff
    buf[2] = val & 0xff
    @writeBuffer buf

  writeUInt24LE: (val) ->
    buf = new Buffer(3)
    buf[0] = val & 0xff
    buf[1] = val >>> 8 & 0xff
    buf[2] = val >>> 16 & 0xff
    @writeBuffer buf

  writeInt24BE: (val) ->
    if val >= 0
      @writeUInt24BE val
    else
      @writeUInt24BE val + 0xffffff + 1

  writeInt24LE: (val) ->
    if val >= 0
      @writeUInt24LE val
    else
      @writeUInt24LE val + 0xffffff + 1

  fill: (val, length) ->
    buf = new Buffer(length)
    buf.fill(val)
    @writeBuffer buf

  end: ->
    @push null

module.exports = EncodeStream
