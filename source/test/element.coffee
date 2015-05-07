should = require 'should'
AbstractElement = require '../element'

describe 'AbstractElement', ->
  describe '#constructor(data)', ->
    it 'should return a element instance', ->
      (new AbstractElement).should.be.an.instanceOf AbstractElement

    it 'should set the element data', ->
      element = new AbstractElement ['test']
      element[0].should.be.equal 'test'

  describe '#clone() method', ->
    it 'should clone the element', ->
      element = new AbstractElement ['test']
      element[0].should.be.equal 'test'
      element = new AbstractElement {test:'test'}
      element.test.should.be.equal 'test'

  describe '#toArray method', ->
    it 'should return the element data as array', ->
      element = new AbstractElement ['test']
      result = element.toArray()
      result.should.be.an.instanceOf Array
      result[0].should.be.equal 'test'

  describe '#toObject method', ->
    it 'should return the element data as object', ->
      element = new AbstractElement ['test']
      result = element.toObject()
      result.should.be.an.instanceOf Object
      result.should.not.be.an.instanceOf Array
      result[0].should.be.equal 'test'

  describe '#toString method', ->
    it 'should return the element data as a string', ->
      element = new AbstractElement ['test']
      (typeof element.toString()).should.be.equal 'string'

  describe '#toJSON method', ->
    it 'should return an object suitable for JSON.stringify', ->
      element = new AbstractElement ['test']
      result = element.toJSON()
      result.should.be.an.instanceOf Object
      element[0].should.be.equal 'test'

  describe '#valueOf method', ->
    it 'should return the data value object', ->
      element = new AbstractElement ['test']
      result = element.valueOf()
      result.should.be.an.instanceOf Object
