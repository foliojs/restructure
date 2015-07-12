{Number:NumberT} = require './Number'

exports.resolveLength = (length, stream, parent) ->
  if typeof length is 'number'
    return length

  if typeof length is 'function'
    return length.call(parent)

  if parent and typeof length is 'string'
    return parent[length]

  if length instanceof NumberT
    return length.decode(stream)

  return null

class PropertyDescriptor
  constructor: (opts = {}) ->
    @enumerable = true
    @configurable = true
    
    for key, val of opts
      this[key] = val

exports.PropertyDescriptor = PropertyDescriptor
