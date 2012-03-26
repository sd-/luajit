-- Bootstrap.
local tinsert = table.insert
local stringmeta=getmetatable("")
local getinfo = debug.getinfo
stringmeta.__mod = function(a,b)
  if type(b)~="table" then
    b={b}
  end
  return string.format(a, unpack(b))
end

-- hackish bootstrap :)
local oldreadable = package.readable
package.readable = function(a,b)
	if a:sub(1,11) ~= "moonscript." and a:sub(-5)==".moon" then
		return
	end
	return oldreadable(a,b)
end

local moonscript = require "moonscript"
local pos_to_line = moonscript.util.pos_to_line

package.readable = oldreadable

local old_loadfile = loadfile
local old_loadstring = loadstring
local line_tables = moonscript.line_tables
function loadstring(str, fn, dump)
	if fn:sub(-5) == '.moon' then
		local passed, code, ltable = pcall(function()
			return moonscript.to_lua(str)
		end)
		if not passed then
			return nil, fn .. ": "..code
		end
		line_tables[fn] = ltable
		if dump then
			local f=io.open(dump,"w+")
			f:write("-- DO NOT EDIT, Generated from "..fn.."\n")
			f:write(code)
			f:close()
		end

    local lcache = {}
    local function reverse_lineno(chunk, lineno)
      local lt=lcache[lineno]
      if lt then return lt end
      for i=lineno,0,-1 do
        lt=ltable[i]
        if lt then
          local col,row=pos_to_line(code, lt)
          if not col then
            print("cannot find",lineno)
          else
            lcache[lineno]=col
            return col
          end
        end
      end
    end
    jit.attach(reverse_lineno, "LINE")
		local res, err = old_loadstring(code, '@'..fn)
    jit.attach(reverse_lineno)
    return res, err
	end
	return old_loadstring(str, '@'..fn)
end

function loadfile(fn)
	if fn:sub(-5) == '.moon' and fn:sub(1,11) ~= "moonscript." then
		return loadstring(io.open(fn):read("*a"), fn, fn:sub(1,-6)..".lua")
	end
	return old_loadfile(fn)
end


