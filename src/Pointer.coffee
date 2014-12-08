class Pointer
  constructor: (@offsetType, @type, @options = {}) ->
    @type = null if @type is 'void'
    @options.type ?= 'local'
    @options.allowNull ?= true
    if @options.relativeTo
      @relativeToGetter = new Function('ctx', "return ctx.#{@options.relativeTo}")

  decode: (stream, ctx) ->
    offset = @offsetType.decode(stream)
    pos = stream.pos

    # handle NULL pointers
    if offset is 0 and @options.allowNull
      return null

    relative = switch @options.type
      when 'local'     then ctx._startOffset
      when 'immediate' then stream.pos - @offsetType.size()
      when 'parent'    then ctx.parent._startOffset
      else
        c = ctx
        while c.parent
          c = c.parent

        c._startOffset

    if @options.relativeTo
      relative += @relativeToGetter ctx

    ptr = offset + relative

    if @type?
      stream.pos = ptr
      res = @type.decode(stream, ctx)
      stream.pos = pos
      return res
    else
      return ptr

  size: (val, ctx) ->
    unless val?
      return @offsetType.size()

    parent = ctx
    switch @options.type
      when 'local', 'immediate'
        break
      when 'parent'
        ctx = ctx.parent
      else # global
        while ctx.parent
          ctx = ctx.parent

    type = @type
    unless type?
      unless val instanceof VoidPointer
        throw new Error "Must be a VoidPointer"

      type = val.type
      val = val.value

    ctx?.pointerSize += type.size(val, parent)
    return @offsetType.size()

  encode: (stream, val, ctx) ->
    parent = ctx
    if not val?
      @offsetType.encode(stream, 0)
      return

    switch @options.type
      when 'local'
        relative = ctx.startOffset
      when 'immediate'
        relative = stream.pos + @offsetType.size(val, parent)
      when 'parent'
        ctx = ctx.parent
        relative = ctx.startOffset
      else # global
        relative = 0
        while ctx.parent
          ctx = ctx.parent

    if @options.relativeTo
      relative += @relativeToGetter parent.val

    @offsetType.encode(stream, ctx.pointerOffset - relative)

    type = @type
    unless type?
      unless val instanceof VoidPointer
        throw new Error "Must be a VoidPointer"

      type = val.type
      val = val.value

    ctx.pointers.push
      type: type
      val: val
      parent: parent

    ctx.pointerOffset += type.size(val, parent)

# A pointer whose type is determined at decode time
class VoidPointer
  constructor: (@type, @value) ->

exports.Pointer = Pointer
exports.VoidPointer = VoidPointer
