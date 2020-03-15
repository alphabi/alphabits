function letterbit(letter)
  return letter > 'm' and '1' or '0'
end
for word in io.lines(arg[1] or '/usr/share/dict/words') do
  local bitmask = word:lower():gsub('[^a-z]', ''):gsub('.', letterbit)
  local outfile = io.open('bitdicts/'..bitmask, 'a')
  outfile:write(word, '\n')
  outfile:close()
end
