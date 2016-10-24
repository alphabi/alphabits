local filename = arg[1]
local firstdot = filename:find('.',1,true)
local strsub = string.sub
local prefix = strsub(filename, 1, firstdot)
local extension = firstdot and strsub(filename, firstdot) or ''
local byte = string.byte
local char = string.char
local strf = string.format
local tonumber = tonumber
local acase = 'A'
local alphastart = byte(acase)
local bitbuffer = {}
local rm1 = byte'I' - alphastart
local rm2 = byte'U' - alphastart - 1
local function oldbaconletter(l)
  if l >= rm2 then
    l = l + 2
  elseif l > rm1 then
    l = l + 1
  end
  return char(alphastart + l)
end
local function baconletter(l)
  return char(alphastart + l)
end
local function letterbit(letter)
  return letter > 'm' and '1' or '0'
end
local function alphabi(s)
  return s:lower():gsub('[^a-z]', ''):gsub('.', letterbit)
end
for line in io.lines(filename) do
  bitbuffer[#bitbuffer+1] = alphabi(line)
end
bitbuffer = table.concat(bitbuffer)
local bitsper = 5
local run = bitsper - 1
for offset=1, bitsper do
  local outname = strf('%sbaconated%i%s', prefix, offset, extension)
  local outfile = io.open(outname, 'w')
  local last = #bitbuffer - bitsper
  for i=offset, last, bitsper do
    outfile:write((oldbaconletter(tonumber(strsub(bitbuffer,i,i+run),2))
      :gsub('[^A-Z]','\n')))
  end
end
