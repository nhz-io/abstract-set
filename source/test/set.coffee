should = require 'should'
Set = require '../set'

handler = (items) ->
  has: (item) -> -1 isnt items.indexOf item
  add: (item) -> items.push item
  remove: (item) -> items.splice (items.indexOf item), 1

describe 'AbstractSet', ->
  describe '#constructor(items...)', ->
    it 'should return a set of given items', ->
      set = Set 1, 2, 3
      set.should.be.an.instanceOf Set
      set.items.length.should.be.equal 3
      set.items[0].should.be.equal 1
      set.items[1].should.be.equal 2
      set.items[2].should.be.equal 3

      set = new Set 1, 2, 3
      set.should.be.an.instanceOf Set
      set.items.length.should.be.equal 3
      set.items[0].should.be.equal 1
      set.items[1].should.be.equal 2
      set.items[2].should.be.equal 3

  describe '#handler(func)', ->
    it 'should return the set', ->
      set = new Set
      set.handler(null).should.be.equal set

    it 'should set new handler', ->
      set = new Set
      _handler = ->
      set.handler(_handler)._handler.should.be.equal _handler

  describe '#clone()', ->
    it 'should clone the set', ->
      set = Set 1, 2, 3
      clone = set.clone()

      clone.should.be.an.instanceOf Set
      clone.should.not.be.equal set
      clone.items.should.not.be.equal set.items
      clone.items.length.should.be.equal 3

      set.items[0].should.be.equal 1
      set.items[1].should.be.equal 2
      set.items[2].should.be.equal 3
      set.items[0].should.be.equal clone.items[0]
      set.items[1].should.be.equal clone.items[1]
      set.items[2].should.be.equal clone.items[2]

  describe '#empty()', ->
    it 'should return true if set is empty', -> (new Set).empty().should.be.equal true
    it 'should return false if set isnt empty', -> (Set 1).empty().should.be.equal false

  describe '#subset(superset)', ->
    it 'should return true if the set is a subset of superset', ->
      set = Set 1, 2, 3
      superset = Set 1, 2, 3
      set.subset(superset).should.be.equal true

    it 'should return false if the set isnt a subset of superset', ->
      set = Set 1, 2, 3
      superset = Set 0, 2, 3
      set.subset(superset).should.be.equal false

      set = (Set 1, 2, 3).handler handler
      superset = (Set 0, 2, 3).handler handler
      set.subset(superset).should.be.equal false

  describe '#superset(subset)', ->
    it 'should return true if the set is a superset of subset', ->
      set = Set 1, 2, 3, 4
      subset = Set 1, 2, 3
      set.superset(subset).should.be.equal true

      set = (Set 1, 2, 3, 4).handler handler
      subset = (Set 1, 2, 3).handler handler
      set.superset(subset).should.be.equal true

    it 'should return false if the set isnt a superset of subset', ->
      set = Set 1, 2, 3
      subset = Set 0, 1, 2
      set.superset(subset).should.be.equal false

      set = (Set 1, 2, 3).handler handler
      subset = (Set 0, 1, 2).handler handler
      set.superset(subset).should.be.equal false

  describe '#has(item)', ->
    it 'should return true if item is in the set', ->
      (Set 1, 2, 3).has(1).should.be.equal true
      (Set 1, 2, 3).handler(handler).has(1).should.be.equal true

    it 'should return false if item isnt in the set', ->
      (Set 1, 2, 3).has(0).should.be.equal false
      (Set 1, 2, 3).handler(handler).has(0).should.be.equal false

  describe '#add(items...)', ->
    it 'should add then items to the set', ->
      set = new Set
      test = set.add 1
      test.should.be.an.instanceof Set
      test.should.not.be.equal set
      test.items.length.should.be.equal 1
      test.items[0].should.be.equal 1

      set = (new Set).handler handler
      test = set.add 1
      test.should.be.an.instanceof Set
      test.should.not.be.equal set
      test.items.length.should.be.equal 1
      test.items[0].should.be.equal 1

    it 'should not add duplicates', ->
      set = new Set 1
      test = set.add 1
      test.should.be.an.instanceof Set
      test.should.be.equal set
      test.items.length.should.be.equal 1
      test.items.length.should.be.equal 1

      set = (Set 1).handler handler
      test = set.add 1
      test.should.be.an.instanceof Set
      test.should.be.equal set
      test.items.length.should.be.equal 1
      test.items.length.should.be.equal 1

  describe '#remove(items...)', ->
    it 'should remove items from the set', ->
      set = new Set 1, 2, 3
      test = set.remove 2, 3
      test.should.be.an.instanceof Set
      test.should.not.be.equal set
      test.items.length.should.be.equal 1
      test.items[0].should.be.equal 1
      set = test.remove 2, 3
      set.should.be.equal test
      set.items.length.should.be.equal 1
      test.items[0].should.be.equal 1

      set = (Set 1, 2, 3).handler handler
      test = set.remove 2, 3
      test.should.be.an.instanceof Set
      test.should.not.be.equal set
      test.items.length.should.be.equal 1
      test.items[0].should.be.equal 1
      set = test.remove 2, 3
      set.should.be.equal test
      set.items.length.should.be.equal 1
      test.items[0].should.be.equal 1

  describe '#union(sets...)', ->
    it 'should return the union of the set with sets', ->
      set = Set 1
      union = set.union [2], [3]
      union.should.be.an.instanceOf Set
      union.should.not.be.equal set
      union.items.length.should.be.equal 3
      union.has(1).should.be.equal true
      union.has(2).should.be.equal true
      union.has(3).should.be.equal true

      set = (Set 1).handler handler
      union = set.union [2], [3]
      union.should.be.an.instanceOf Set
      union.should.not.be.equal set
      union.items.length.should.be.equal 3
      union.has(1).should.be.equal true
      union.has(2).should.be.equal true
      union.has(3).should.be.equal true

  describe '#complement(sets...)', ->
    it 'should return the complement of the set to the sets', ->
      set = Set 1
      complement = set.complement [1, 2], [2, 3], [3, 1]
      complement.should.be.an.instanceOf Set
      complement.should.not.be.equal set
      complement.items.length.should.be.equal 2
      complement.has(1).should.be.equal false
      complement.has(2).should.be.equal true
      complement.has(3).should.be.equal true

      set = (Set 1).handler handler
      complement = set.complement [1, 2], [2, 3], [3, 1]
      complement.should.be.an.instanceOf Set
      complement.should.not.be.equal set
      complement.items.length.should.be.equal 2
      complement.has(1).should.be.equal false
      complement.has(2).should.be.equal true
      complement.has(3).should.be.equal true

  describe '#difference(sets...)', ->
    it 'should return the symmetric difference of the set and sets', ->
      set = Set 1, 3, 2, 4
      difference = set.difference [2, 3, 5, 6], [ 3, 4, 6, 7]
      difference.should.be.an.instanceOf Set
      difference.should.not.be.equal set
      difference.items.length.should.be.equal 4
      difference.has(1).should.be.equal true
      difference.has(3).should.be.equal true
      difference.has(5).should.be.equal true
      difference.has(7).should.be.equal true

      set = (Set 1, 3, 2, 4).handler handler
      difference = set.difference [2, 3, 5, 6], [ 3, 4, 6, 7]
      difference.should.be.an.instanceOf Set
      difference.should.not.be.equal set
      difference.items.length.should.be.equal 4
      difference.has(1).should.be.equal true
      difference.has(3).should.be.equal true
      difference.has(5).should.be.equal true
      difference.has(7).should.be.equal true

  describe '#intersect(sets...)', ->
    it 'should return the intersect of the set with sets', ->
      set = Set 1, 3, 2, 4
      intersect = set.intersect [2, 3, 5, 6], [ 3, 4, 6, 7]
      intersect.should.be.an.instanceOf Set
      intersect.should.not.be.equal set
      intersect.items.length.should.be.equal 1
      intersect.has(3).should.be.equal true
