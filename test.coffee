# ======= Test Dependencies =======

#expect = (require 'chai').expect
testability = (require './dist/testability')(require)



# ============= Tests =============

describe 'testability', ->
  
  it 'works', ->
    console.log testability.load('./fixtures/a', {
      "./b": 'xxx'
    })
    require './test/fixtures/a'