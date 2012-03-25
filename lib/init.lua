-- Bootstrap.
local stringmeta=getmetatable("")
stringmeta.__mod = stringmeta.format
local old_loadfile = loadfile

function loadstring(str,chunk)
end

function loadfile(fn)
	if fn:sub(-5) == '.moon' then
		local code, err = parse_moon(io.open(fn,"r"):read("*a"))
		if code then
			return loadstring(code, fn)
		end
		return code, err
	end
	return old_loadfile(fn)
end
