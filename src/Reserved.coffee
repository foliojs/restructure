class Reserved
  constructor: (@type, @count = 1) ->    
  decode: (stream) ->
    stream.pos += @size()
    return undefined
    
  size: ->
    @type.size() * @count
    
  encode: (stream) ->
    stream.fill 0, @size()
    
module.exports = Reserved
