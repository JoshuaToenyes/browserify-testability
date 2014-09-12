testability = (require './../dist/testability')(require)
expect = (require 'chai').expect

describe 'browserify-testability', ->

  beforeEach ->
    testability.restoreAll()
    expect(require './fixtures/a').to.eql('abc')


  it 'simply requires modules if no double is specified', ->
    a = testability.require './fixtures/a'
    b = testability.require './fixtures/b'
    c = testability.require './fixtures/c'
    expect(a).to.eql('abc')
    expect(b).to.eql('b')
    expect(c).to.eql('c')

  describe '#require', ->

    it 'replaces modules with passed doubles', ->
      a = testability.require './fixtures/a', {
        './b': 'zzz'
      }
      expect(a).to.eql('azzzc')

    it 'double modules go out of scope after require', ->
      a = testability.require './fixtures/a', {'./b': 'zzz'}
      expect(testability.require('./fixtures/a')).to.eql('abc')

    it 'can replace more than one module', ->
      a = testability.require './fixtures/a', {
        './b': 'zzz'
        './c': 'www'
      }
      expect(a).to.eql('azzzwww')

    it 'splits paths with spaces', ->
      a = testability.require './fixtures/a', {
        './b ./c': 'zzz'
      }
      expect(a).to.eql('azzzzzz')

    it 'splits paths with commas', ->
      a = testability.require './fixtures/a', {
        './b, ./c': 'zzz'
      }
      expect(a).to.eql('azzzzzz')

    it 'splits paths with bars', ->
      a = testability.require './fixtures/a', {
        './b | ./c': 'zzz'
      }
      expect(a).to.eql('azzzzzz')

    it 'splits paths with nasty mixtures of bars, spaces, and commas', ->
      a = testability.require './fixtures/a', {
        './b|, ./c': 'zzz'
      }
      expect(a).to.eql('azzzzzz')

    it 'can recursively replace modules', ->
      a = testability.require './fixtures/a', {
        './b': testability.require('./fixtures/a', {'./c': '123'})
      }
      expect(a).to.eql('aab123c')


  describe '#replace', ->

    it 'replaces the module for future require calls', ->
      testability.replace({
        './b': 'zzz'
      })
      expect(testability.require './fixtures/a').to.eql('azzzc')
      testability.replace({
        './c': 'wxy'
      })
      expect(testability.require './fixtures/a').to.eql('azzzwxy')

    it 'overwrites doubles with multiple calls', ->
      testability.replace({
        './b': 'zzz'
        './c': 'www'
      })
      expect(testability.require './fixtures/a').to.eql('azzzwww')
      testability.replace({
        './b': '111'
        './c': '222'
      })
      expect(testability.require './fixtures/a').to.eql('a111222')


  describe '#restore', ->

    it 'restores doubled modules to the original', ->
      testability.replace({
        './b': 'zzz'
      })
      expect(testability.require './fixtures/a').to.eql('azzzc')
      testability.restore('./b')
      expect(testability.require './fixtures/a').to.eql('abc')


  describe '#has', ->

    it 'returns true for double modules', ->
      expect(testability.has('./b')).to.be.false
      testability.replace({
        './b': 'zzz'
      })
      expect(testability.has('./b')).to.be.true


  describe '#get', ->

    it 'returns the doubled module, or undefined', ->
      expect(testability.get('./b')).to.be.undefined
      testability.replace({
        './b': 'zzz'
      })
      expect(testability.get('./b')).to.equal('zzz')