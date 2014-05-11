class BufferT
  constructor: (@length) ->
  decode: (stream, parent) ->
    length = @length
    if parent and typeof length is 'string'
      length = parent[length]
      
    return stream.readBuffer(length)
    
  size: (val) ->
    return val.length
    
  encode: (stream, buf, parent) ->
    stream.writeBuffer(buf)
    
module.exports = BufferT
