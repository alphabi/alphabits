-- localize deps
local byte = string.byte
local char = string.char
local strf = string.format
local sstr = string.sub
local lower = string.lower
local upper = string.upper
local gsub = string.gsub
local tonumber = tonumber

-- run options
local cipherversion
local filename
local low = '0'
local high = '1'

-- process flags
while arg[1] and sstr(arg[1],1,1) == '-' do
  for i=2, #arg[1] do
    local flag = sstr(arg[1],i,i)
    if flag == 'i' then
      low = '1'
      high = '0'
    elseif flag == 'c' then
      cipherversion = 'c'
    elseif flag == 'm' then
      cipherversion = 'm'
    else
      io.stderr:write('Unrecognized flag "',flag,'"\n')
    end
  end
  table.remove(arg, 1)
end

-- TODO: warn about implicit modern cipher
cipherversion = cipherversion or 'm'

query = gsub(lower(arg[1]),'%L+','')
filename = arg[2]

local bitbuffer = {}

local decipher
local alphastart = byte'a'
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
      return '_'
    end
end

else -- cypherversion = 'm'
  alphaspan = 26
  decipher = function (pos)
    if pos < alphaspan then
      return char(alphastart + pos)
    else
      return '_'
    end
  end
end


local bitsper = 5
local run = bitsper - 1
local holdfrom = -#query + 1
local searchbits = ''
local bitsread = 0
local compstrs = {'','','','',''}

local function letterbit(letter)
  return letter > 'm' and '1' or '0'
end
local function alphabi(s)
  return gsub(gsub(lower(s), '%L+',''), '%l', letterbit)
end
local linenum = 0
local found = false
for line in io.lines(filename) do
  linenum = linenum + 1
  searchbits = searchbits .. alphabi(line)
  while #searchbits > bitsper do
    local compslot = (bitsread % bitsper) + 1
    local pos = tonumber(sstr(searchbits,1,5), 2)
    local candidate = sstr(compstrs[compslot], holdfrom) .. decipher(pos)
    if candidate == query then
      print(strf('"%s" found at line %i', upper(query), linenum))
      found = true
    end
    compstrs[compslot] = candidate
    searchbits = sstr(searchbits, 2)
    bitsread = bitsread + 1
  end
end
if not found then
  print(strf('"%s" not found in %s', upper(query), filename))
end
