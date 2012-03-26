-- Bootstrap.
local tinsert = table.insert
local stringmeta = getmetatable("")
local getinfo = debug.getinfo
local date = os.date
stringmeta.__mod = function(a,b)
  if type(b)~="table" then
    b={b}
  end
  return string.format(a, unpack(b))
end

-- hackish bootstrap :)
local oldreadable = package.readable
package.readable = function(a,b)
	if (a:sub(1,11) ~= "moonscript.") and (a:sub(1,5)~="moon.") and a:sub(-5)==".moon" then
		return
	end
	return oldreadable(a,b)
end

local moonscript = require "moonscript"
require "moonscript.util"
local compile = require "moonscript.compile"
local parse = require "moonscript.parse"
local pos_to_line = moonscript.util.pos_to_line

package.readable = oldreadable

local old_loadfile = loadfile
local old_loadstring = loadstring
local line_tables = moonscript.line_tables
function loadstring(str, fn, dump)
	if fn:sub(-5) == '.moon' then
		local passed, code, ltable = pcall(function()
      local tree, err = parse.string(str)
      if not tree then
        error(err, 2)
      end
      local code, ltable, pos = compile.tree(tree)
      if not code then
        error(compile.format_error(ltable, pos, str), 2)
      end
      return code, ltable
--			return moonscript.to_lua(str)
		end)
		if not passed then
			return nil, fn .. ": "..code
		end
		line_tables[fn] = ltable
		if dump then
			local f=io.open(dump,"w+")
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
          local row,col = pos_to_line(str, lt)
          --print(lineno,lt,row,col)
          if not row then
          else
            lcache[lineno]=row
            return row
          end
        end
      end
--      print("default lineno!",lineno)
      return lineno
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

require "strict"

--[[
package.zip = {}

local ZIP = require "zip"
local arch = io.open(os.progname, "r")
if not arch then
  arch = io.open("/proc/self/exe", "r")
end

--if arch then
--  package.zip.__init = ZIP(arch)
end]]


