AbstractElement = require './element'
module.exports = class AbstractSet extends AbstractElement
  constructor: (elements = []) ->
    for element in elements
      continue unless element
      switch
        when element instanceof AbstractElement then @add element
        when element instanceof Object then @add new AbstractElement element

  add: (element) ->
    @push element if element instanceof AbstractElement and -1 is @indexOf element
    return this

  has: (element) -> if -1 isnt @indexOf element then true else false

  remove: (element) ->
    if -1 isnt i = @indexOf element
      @splice i, 1
    return this

  union: (sets...) ->
    result = @clone()
    for set in sets
      result.add element for element in set
    return result

  difference: (sets...) ->
    result = @clone()
    for set in sets
      union = result.union set
      for element in union
        if (result.has element) and (set.has element)
          union.remove element
      result = union
    return result

  intersect: (sets...) ->
    union = @union.apply this, sets
    result = union.clone()
    count = sets.length + 1
    for element in union
      _count = if @has element then 1 else 0
      for set in sets
        _count++ if set.has element
      result.remove element if _count isnt count
    return result





