-- localize deps
local byte = string.byte
local char = string.char
local strf = string.format
local sstr = string.sub
local lower = string.lower
local gsub = string.gsub
local tonumber = tonumber

-- run options
local cipherversion
local filename
local startat = 1
local acase = 'A'

-- process flags
while arg[1] and sstr(arg[1],1,1) == '-' do
  for i=2, #arg[1] do
    local flag = sstr(arg[1],i,i)
    if flag == 'l' then
      acase = 'a'
    elseif flag == 'c' then
      cipherversion = 'c'
    elseif flag == 'm' then
      cipherversion = 'm'
    elseif flag == '1' or flag == '2' or flag == '3'
      or flag == '4' or flag == '5' then
      startat = tonumber(flag)
    elseif flag == 'a' then
      startat = 'all'
    else
      io.stderr:write('Unrecognized flag "',flag,'"\n')
    end
  end
  table.remove(arg, 1)
end

-- TODO: warn about implicit modern cipher
cipherversion = cipherversion or 'm'

filename = arg[1]

local bitbuffer = {}

local decipher
local alphastart = byte(acase)
local alphaspan

if cipherversion == 'c' then
  alphaspan = 24
  local rm1 = byte'I' - byte'A'
  local rm2 = byte'U' - byte'A' - 1
  decipher = function (pos)
    if pos < alphaspan then
      if pos >= rm2 then
        pos = pos + 2
      elseif pos > rm1 then
        pos = pos + 1
      end
      return char(alphastart + pos)
    else
      return (pos - alphaspan + 1) .. '\n'
    end
end

else -- cypherversion = 'm'
  alphaspan = 26
  decipher = function (pos)
    if pos < alphaspan then
      return char(alphastart + pos)
    else
      return (pos - alphaspan + 1) .. '\n'
    end
  end
end

local function letterbit(letter)
  return letter > 'm' and '1' or '0'
end
local function alphabi(s)
  return gsub(gsub(lower(s), '%L+',''), '%l', letterbit)
end
for line in io.lines(filename) do
  bitbuffer[#bitbuffer+1] = alphabi(line)
end
bitbuffer = table.concat(bitbuffer)

local bitsper = 5
local run = bitsper - 1
local function writefrom(outfile, start)
  local last = #bitbuffer - bitsper
  for i = start, last, bitsper do
    local pos = tonumber(sstr(bitbuffer, i, i + run), 2)
    if not pos then print(sstr(bitbuffer, i, i + run)) end
    outfile:write(decipher(pos))
  end
end

if startat == 'all' then
  local firstdot = filename:find('.',1,true)
  local prefix = sstr(filename, 1, firstdot)
  local extension = firstdot and filename:sub(firstdot) or ''
  for start = 1, bitsper do
    local outname = strf('%s%sbac%i%s',
      prefix, cipherversion, start, extension)
    local outfile = io.open(outname, 'w')
    writefrom(outfile, start)
  end
else
  writefrom(io.stdout, startat)
end
