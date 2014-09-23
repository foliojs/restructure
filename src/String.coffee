{Number:NumberT} = require './Number'
utils = require './utils'

class StringT
  constructor: (@length, @encoding = 'ascii') ->
    
  decode: (stream, parent) ->
    length = utils.resolveLength @length, stream, parent
    encoding = @encoding
    if typeof encoding is 'function'
      encoding = encoding.call(parent) or 'ascii'
      
    return stream.readString(length, encoding)
    
  size: (val, parent) ->
    encoding = @encoding
    if typeof encoding is 'function'
      encoding = encoding.call(parent?.val) or 'ascii'
      
    if encoding is 'utf16be'
      encoding = 'utf16le'
    
    size = Buffer.byteLength(val, encoding)
    if @length instanceof NumberT
      size += @length.size()
      
    return size
    
  encode: (stream, val, parent) ->
    encoding = @encoding
    if typeof encoding is 'function'
      encoding = encoding.call(parent?.val) or 'ascii'
    
    if @length instanceof NumberT
      @length.encode(stream, Buffer.byteLength(val, encoding))
            
    stream.writeString(val, encoding)
    
module.exports = StringT
