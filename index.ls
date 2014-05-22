require! <[fs ./range ./check]>

recurse-dir = (root) ->
  if !fs.exists-sync root => return []
  if !fs.statSync(root)isDirectory! => return if /\.png$/.exec root => [root] else []
  files = ["#root/#f" for f in fs.readdir-sync(root)]
  ret = []
  for file in files
    ret ++= recurse-dir file
  return ret

list = recurse-dir(\img)

pat = /(\d+)\/(\d+)\/(\d+).png/
bitvector = {}
for file in list
  ret = pat.exec file
  if !ret => continue
  [z,x,y] = ret[1 to 3]map -> parseInt it
  if !range[z] and z <= 11 => continue
  bitvector[z] ?= {}
  if !bitvector[z][y] =>
    if z >= 12 =>
      o = z - 11
      oy = y .>>. o
      if !range.11[oy] => continue
      min = Math.min.apply(null, ((range.11[oy]2 or []) ++ [range.11[oy]0])) .<<. o
      max = Math.max.apply(null, ((range.11[oy]2 or []) ++ [range.11[oy]1])) .<<. o
      len = Math.ceil((max - min) / 32)
    else
      if !range[z][y] => continue
      min = Math.min.apply(null, ((range[z][y]2 or []) ++ [range[z][y]0]))
      max = Math.max.apply(null, ((range[z][y]2 or []) ++ [range[z][y]1]))
      len = Math.ceil((max - min) / 32)
    bitvector[z][y] = [min, max, [0 for i from 0 til len]]
  bv = bitvector[z][y]
  dx = (x - bv.0)
  o = parseInt(dx / 32)
  v = 1 .<<. (31 - parseInt(dx % 32))
  bv.2[o] .|.= v

fs.write-file-sync \map.json, JSON.stringify bitvector

# sample check usage for testing

test-points =
  * false,   1,    1,    1
  * true,    9,  427,  224
  * false,   9,  427,  225
  * false,  11, 1715,  878
  * true,   12, 3431, 1753

for p in test-points
  ret = check bitvector, p.1, p.2, p.3
  if ret != p.0 => console.log " test case #{p.1}, #{p.2}, #{p.3} failed. "
