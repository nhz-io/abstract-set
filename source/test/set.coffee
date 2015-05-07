should = require 'should'
AbstractElement = require '../element'
AbstractSet = require '../set'

describe 'AbstractSet', ->
  describe '#constructor(elements)', ->
    it 'should return a set instance', ->
      (new AbstractSet).should.be.an.instanceOf AbstractElement
      (new AbstractSet).should.be.an.instanceOf AbstractSet

    it 'should add the elements of AbstractElement type', ->
      element = new AbstractElement
      set = new AbstractSet [element]
      set[0].should.be.equal element

    it 'should not add the elements not of AbstractElement type', ->
      set = new AbstractSet ['test']
      set.length.should.be.equal 0

    it 'should create AbstractElements if source data is an object', ->
      obj = test:'test'
      set = new AbstractSet [ obj ]
      set[0].test.should.be.equal 'test'

  describe '#add(element)', ->
    it 'should add element to the set if it is of AbstractElement type', ->
      element = new AbstractElement
      set = new AbstractSet
      set.add element
      set.length.should.be.equal 1
      set[0].should.be.equal element

    it 'should not add element to the set if it is not of AbstractElement type', ->
      set = new AbstractSet
      set.add 'test'
      set.length.should.be.equal 0

    it 'should not add same element twice', ->
      element = new AbstractElement
      set = new AbstractSet
      set.add element
      set.length.should.be.equal 1
      set.add element
      set.length.should.be.equal 1

  describe '#remove(element)', ->
    it 'should remove the element from the set', ->
      element = new AbstractElement
      set = new AbstractSet
      set.add element
      set.length.should.be.equal 1
      set.remove element
      set.length.should.be.equal 0

  describe '#has(element)', ->
    it 'should return true if the element is in the set', ->
      element = new AbstractElement
      set = new AbstractSet [element]
      set.has(element).should.be.equal true

    it 'should return false if the element is not in the set', ->
      element = new AbstractElement
      set = new AbstractSet [element]
      element = new AbstractElement
      set.has(element).should.be.equal false

  describe '#union(sets...)', ->
    it 'should return a new set which is a union of all sets', ->

      elements = new AbstractSet [
        new AbstractElement
        new AbstractElement
        new AbstractElement
      ]

      one = new AbstractSet [elements[0]]
      two = new AbstractSet [elements[1]]
      three = new AbstractSet [elements[2]]

      test = one.union two, three

      test.length.should.be.equal 3

      test[0].should.be.equal elements[0]
      test[1].should.be.equal elements[1]
      test[2].should.be.equal elements[2]

  describe '#difference(sets...)', ->
    it 'should return a new set which is a difference of all sets', ->

      elements = new AbstractSet [
        new AbstractElement
        new AbstractElement
        new AbstractElement
        new AbstractElement
      ]

      one = new AbstractSet [elements[0], elements[1], elements[3]]
      two = new AbstractSet [elements[1], elements[2]]
      three = new AbstractSet [elements[2], elements[0]]

      test = one.difference two, three

      test.length.should.be.equal 1
      test[0].should.be.equal elements[3]

  describe '#intersect(sets...)', ->
    it 'should return an new set which is an intersection of all sets', ->

      elements = new AbstractSet [
        new AbstractElement [0]
        new AbstractElement [1]
        new AbstractElement [2]
        new AbstractElement [3]
      ]

      one = new AbstractSet [elements[0], elements[3]]
      two = new AbstractSet [elements[1], elements[3]]
      three = new AbstractSet [elements[2], elements[3]]

      test = one.intersect two, three
      test.length.should.be.equal 1

      test[0].should.be.equal elements[3]
