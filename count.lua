local bitmasks = {}
function letterbit(letter)
  return letter > 'm' and '1' or '0'
end
for word in io.lines(arg[1] or '/usr/share/dict/words') do
  local bitmask = word:lower():gsub('[^a-z]', ''):gsub('.', letterbit)
  local count = bitmasks[bitmask] or 0
  bitmasks[bitmask] = count + 1
end
local ranks = {}
for mask, count in pairs(bitmasks) do
  ranks[#ranks+1] = {mask, count}
end
table.sort(ranks,function(m,n) return m[2] > n[2] end)
for i=1, #ranks do
  local bitmask = ranks[i]
  print(bitmask[1], bitmask[2])
end
