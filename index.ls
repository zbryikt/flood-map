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
  if !range[z] => continue
  bitvector[z] ?= {}
  if !bitvector[z][y] =>
    min = Math.min((range[z]2 or []) ++ [range[z][y]0])
    max = Math.max((range[z]2 or []) ++ [range[z][y]1])
    len = Math.ceil((max - min) / 32)
    bitvector[z][y] = [min, max, [0 for i from 0 til len]]
  bv = bitvector[z][y]
  dx = (x - bv.0)
  o = parseInt(dx / 32)
  v = 1 .<<. (31 - parseInt(dx % 32))
  bv.2[o] .|.= v

fs.write-file-sync \map.json, JSON.stringify bitvector

# sample check usage
# console.log(check bitvector, 1, 1, 1)
# console.log(check bitvector, 9, 427, 224)
# console.log(check bitvector, 9, 427, 225)
