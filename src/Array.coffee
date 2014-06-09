{Number:NumberT} = require './Number'

class ArrayT
  constructor: (@type, @length) ->
    
  decode: (stream, parent) ->
    pos = stream.pos
    length = @length
    
    res = []
    ctx = parent
    
    if typeof length is 'function'
      length = length.call(parent)
    
    if parent and typeof length is 'string'
      length = parent[length]
      
    if length instanceof NumberT
      length = length.decode(stream)
      
      # define hidden properties    
      Object.defineProperties res,
        parent:         { value: parent }
        _startOffset:   { value: pos }
        _currentOffset: { value: 0, writable: true }
        _length:        { value: length }
        
      ctx = res
    
    if parent?._length and not length?
      while stream.pos < parent._length + parent._startOffset
        res.push @type.decode(stream, ctx)
    
    else
      for i in [0...length] by 1
        res.push @type.decode(stream, ctx)
      
    return res
    
  size: (array, ctx) ->
    size = 0
    if @length instanceof NumberT
      size += @length.size()
      ctx = parent: ctx
      
    for item in array
      size += @type.size(item, ctx)
      
    return size
    
  encode: (stream, array, parent) ->
    ctx = parent
    if @length instanceof NumberT
      ctx = 
        pointers: []
        startOffset: stream.pos
        parent: parent
        
      ctx.pointerOffset = stream.pos + @size(array, ctx)
      @length.encode(stream, array.length)
      
    for item in array
      @type.encode(stream, item, ctx)
      
    if @length instanceof NumberT
      i = 0
      while i < ctx.pointers.length
        ptr = ctx.pointers[i++]
        ptr.type.encode(stream, ptr.val)
      
    return
    
module.exports = ArrayT
