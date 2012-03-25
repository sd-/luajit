-- Bootstrap.
local stringmeta=getmetatable("")
stringmeta.__mod = stringmeta.format

-- hackish bootstrap :)
local oldreadable = package.readable
package.readable = function(a,b)
	if a:sub(1,11) ~= "moonscript." and a:sub(-5)==".moon" then
		return
	end
	return oldreadable(a,b)
end

local moonscript = require "moonscript"

package.readable = oldreadable

local old_loadfile = loadfile
local old_loadstring = loadstring
local line_tables = {}
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
		return old_loadstring(code, '@'..fn)
	end
	return old_loadstring(str, '@'..fn)
end

function loadfile(fn)
	if fn:sub(-5) == '.moon' and fn:sub(1,11) ~= "moonscript." then
		return loadstring(io.open(fn):read("*a"), fn, fn:sub(1,-6)..".lua")
	end
	return old_loadfile(fn)
end
