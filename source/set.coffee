module.exports = class Set
  constructor: (items...) ->
    if this instanceof Set
      @items = items.slice()
      @_handler = undefined
      @handler = (handler) ->
        if arguments.length > 0
          if typeof handler is 'function'
            _ = (handler []) or {}
            if _.has and _.add and _.remove and _.json and _.value and _.empty and _.size
              @_handler = handler
            else
              @_handler = (items) ->
                methods = (handler items) or {}
                methods.has ||= (item) -> -1 isnt items.indexOf item
                methods.add ||= (item) ->
                  if -1 is items.indexOf item then items.push item
                methods.remove ||= (item) ->
                  if -1 isnt idx = items.indexOf item then items.splice idx, 1
                methods.json ||= (item) -> item
                methods.value ||= (item) -> item
                methods.empty ||= -> items.length is 0
                methods.size ||= -> items.length
                return methods
          unless handler then @_handler = undefined
          return this
        return @_handler
    else
      set = new Set
      set.items = items.slice()
      return set

  clone: ->
    set = (new Set).handler @_handler
    set.items = @items.slice()
    return set

  empty: ->
    if typeof @_handler is 'function'
      return @_handler(@items).size() is 0
    return @items.length is 0

  size: ->
    if typeof @_handler is 'function'
      return @_handler(@items).size()
    return @items.length

  subset: (set) ->
    items = (if set instanceof Set then set.items else set) or []
    if (typeof @_handler is 'function')
      for item in @items
        return false unless @_handler(items).has item
    else
      for item in @items
        return false if -1 is items.indexOf item
    return true

  superset: (set) ->
    items = (if set instanceof Set then set.items else set) or []
    if (typeof @_handler is 'function')
      for item in items
        return false unless @_handler(@items).has item
    else
      for item in items
        return false if -1 is @items.indexOf item
    return true

  has: (item) ->
    if (typeof @_handler is 'function')
      return @_handler(@items).has item
    else
      return (-1 isnt @items.indexOf item)

  add: (items...) ->
    set = @clone()
    if (typeof @_handler is 'function')
      for item in items
        @_handler(set.items).add item unless @_handler(set.items).has item
    else
      for item in items
        set.items.push item if -1 is set.items.indexOf item
    return (if set.items.length is @items.length then this else set)

  remove: (items...) ->
    set = @clone()
    if (typeof @_handler is 'function')
      for item in items
        @_handler(set.items).remove item if @_handler(set.items).has item
    else
      for item in items
        set.items.splice idx, 1 if -1 isnt idx = set.items.indexOf item
    return (if set.items.length is @items.length then this else set)

  union: (sets...) ->
    set = @clone()
    if (typeof @_handler is 'function')
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          @_handler(set.items).add item unless @_handler(set.items).has item
    else
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          set.items.push item if -1 is set.items.indexOf item
    return set

  complement: (sets...) ->
    set = (new Set).handler @_handler
    if (typeof @_handler is 'function')
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          unless (@_handler(@items).has item) or @_handler(set.items).has item
            @_handler(set.items).add item
    else
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          if (-1 is @items.indexOf item) and -1 is set.items.indexOf item
            set.items.push item
    return set

  difference: (sets...) ->
    set = @clone()
    if (typeof @_handler is 'function')
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          if @_handler(set.items).has item
            @_handler(set.items).remove item
          else
            @_handler(set.items).add item
    else
      for items in sets
        items = (if items instanceof Set then items.items else items) or []
        for item in items
          if -1 isnt idx = set.items.indexOf item
            set.items.splice idx, 1
          else
            set.items.push item
    return set

  intersect: (sets...) ->
    union = @union.apply this, sets
    sets.push @items
    set = (new Set).handler @_handler

    if (typeof @_handler is 'function')
      for item in union.items
        intersect = true
        for items in sets
          unless @_handler(items).has item
            intersect = false
            break
        @_handler(set.items).add item if intersect
    else
      for item in union.items
        intersect = true
        for items in sets
          if -1 is items.indexOf item
            intersect = false
            break
        set.items.push item if intersect
    return set

  toJSON: ->
    result = []
    if (typeof @_handler is 'function')
      for item in @items
        result.push @_handler(@items).json item
    else
      for item in @items
        result.push (if typeof item?.toJSON is 'function' then item.toJSON() else item)
    return result

  valueOf: ->
    result = []
    if (typeof @_handler is 'function')
      for item in @items
        result.push @_handler(@items).value item
    else
      for item in @items
        result.push (if typeof item?.valueOf is 'function' then item.valueOf() else item)
    return result
