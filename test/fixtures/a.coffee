b = require './b'
c = require './c'
#chai = require 'chai'

module.exports = 'a' + b + c

#console.log 'chai: ', chai
console.log 'executing A', module.exports
