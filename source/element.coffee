module.exports = class AbstractElement extends Array
  constructor: (data = []) ->
    data = data.valueOf?() or data
    this[key] = value for key, value of data
    if data.length? then @length = data.length

  clone: -> new @constructor this

  toArray: ->
    result = []
    for key, value of this
      if @hasOwnProperty key
        result[key] = value
    return result

  toObject: ->
    result = {}
    for key, value of this
      if @hasOwnProperty key
        result[key] = value
    return result

  toString: -> try return JSON.stringify this

  toJSON: ->
    result = {}
    for key, value of this
      if @hasOwnProperty key
        if typeof value?.toJSON is 'function' then value = value.toJSON()
        result[key] = value
    delete result.length unless result.length
    return result

  valueOf: ->
    result = []
    for key, value of this
      if @hasOwnProperty key
        if typeof value?.valueOf is 'function' then value = value.valueOf()
        result[key] = value
    return result
