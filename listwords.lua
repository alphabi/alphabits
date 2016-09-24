local prefix = 'bitdicts/'
local bits = arg[1]
local tips = {}

function least(t)
  local lk, lv = next(t)
  local ck, cv = next(t, lk)
  while ck do
    if cv < lv then lk, lv = ck, cv end
    ck, cv = next(t, ck)
  end
  return lk
end
function readtip(file)
  local tip = file:read()
  tips[file] = tip
  if not tip then file:close() end
end

for i = 1, #bits do
  local file = io.open(prefix .. bits:sub(1, i))
  if file then readtip(file) end
end

local topfile = least(tips)
while topfile do
  print(tips[topfile])
  readtip(topfile)
  topfile = least(tips)
end
