utils = require './utils'

class BufferT
  constructor: (@length) ->
  decode: (stream, parent) ->
    length = utils.resolveLength @length, stream, parent
    return stream.readBuffer(length)

  size: (val) ->
    return val.length

  encode: (stream, buf, parent) ->
    stream.writeBuffer(buf)

module.exports = BufferT
