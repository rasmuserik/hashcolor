# Install
#
#     bower install hashcolor
#     npm install hashcolor
#
#
# Usage:
#
#     > hashcolor.light("foo");
#     '#fbeaea'
#     > hashcolor.dark("foo");
#     '#3a2826'
#     > hashcolor.val("foo");
#     7688524
#     > hashcolor.intToColor(0xF00BA8)
#     "#F00BA8" 
#     > hashcolor.strHash "foo"
#     160415585
#     > hashcolor.prng 123
#     1218640798
#
#
#{{{1 Literate source code
#
#{{{2 Globals
#
# Define `isNodeJs` and `runTest` in such a way that they will be fully removed by `uglifyjs -mc -d isNodeJs=false -d runTest=false `
#
if typeof isNodeJs == "undefined" or typeof runTest == "undefined" then do ->
  root = if typeof global == "undefined" then window else global
  root.isNodeJs = (typeof window == "undefined") if typeof isNodeJs == "undefined"
  root.runTest = isNodeJs and process.argv[2] == "test" if typeof runTest == "undefined"

#{{{2 Actual implementation
hashcolor = {}

# hashing based on djb
hashcolor.strHash = (s) ->
  hash = 5381
  i = s.length
  while i
    hash = (hash*31 + s.charCodeAt(--i)) | 0
  hash

# pseudorandom number, to make sure hash value uses at least 24 bit, even for single character strings
hashcolor.prng = (n) -> (1664525 * n + 1013904223) |0

# convert integer to hexcolor
hashcolor.intToColor = (i) -> "#" + ((i & 0xffffff) + 0x1000000).toString(16).slice(1)

# return an integer color base on hash
hashcolor.val = (str) -> hashcolor.prng hashcolor.strHash str

# Light and dark version of the color, ready to use in css
hashcolor.light = (str) -> hashcolor.intToColor ((hashcolor.val str) >> 4) | 0xe0e0e0
hashcolor.dark = (str) -> hashcolor.intToColor (hashcolor.val str) & 0x7f7f7f

#{{{2 export
if isNodeJs
  module.exports = hashcolor
else
  window.hashcolor = hashcolor

