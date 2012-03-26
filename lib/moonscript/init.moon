module "moonscript", package.seeall

require "moonscript.compile"
require "moonscript.parse"
require "moonscript.util"

export to_lua, dirsep, line_tables

dirsep = "/"
line_tables = {}

-- create moon path package from lua package path
create_moonpath = (package_path) ->
  paths = split package_path, ";"
  for i, path in ipairs paths
    p = path\match "^(.-)%.lua$"
    if p then paths[i] = p..".moon"
  concat paths, ";"

to_lua = (text) ->
  if "string" != type text
    t = type text
    error "expecting string (got ".. t ..")", 2

  tree, err = parse.string text
  if not tree
    error err, 2

  code, ltable, pos = compile.tree tree
  if not code
    error compile.format_error(ltable, pos, text), 2

  code, ltable


