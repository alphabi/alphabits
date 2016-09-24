local prefix = 'bitdicts/'
local bits = arg[1]
local words = {}
for i = 1, #bits do
  local dictfile = io.open(prefix .. bits:sub(1, i))
  if dictfile then
    for word in dictfile:lines() do
      words[#words+1] = word
    end
  end
end
table.sort(words)
for i = 1, #words do
  print(words[i])
end
