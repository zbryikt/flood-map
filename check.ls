check = (bv, z, x, y) ->
  if !bv or !bv[z] or !bv[z][y] => return false
  yv = bv[z][y]
  if yv.0 > x or yv.1 < x => return false
  dx = x - yv.0
  o = parseInt(dx / 32)
  v = 1 .<<. (31 - (dx % 32))
  return if (yv.2[o] .&. v) => true else false

module ?= {}
module.exports = check
