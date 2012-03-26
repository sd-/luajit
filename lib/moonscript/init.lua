-- DO NOT EDIT, Generated from moonscript/init.moon on Mon Mar 26 03:09:21 2012
module("moonscript", package.seeall)
require("moonscript.compile")
require("moonscript.parse")
require("moonscript.util")
dirsep = "/"
line_tables = { }
local create_moonpath
create_moonpath = function(package_path)
  local paths = split(package_path, ";")
  for i, path in ipairs(paths) do
    local p = path:match("^(.-)%.lua$")
    if p then
      paths[i] = p .. ".moon"
    end
  end
  return concat(paths, ";")
end
to_lua = function(text)
  if "string" ~= type(text) then
    local t = type(text)
    error("expecting string (got " .. t .. ")", 2)
  end
  local tree, err = parse.string(text)
  if not tree then
    error(err, 2)
  end
  local code, ltable, pos = compile.tree(tree)
  if not code then
    error(compile.format_error(ltable, pos, text), 2)
  end
  return code, ltable
end