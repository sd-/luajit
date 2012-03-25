module("moonscript.types", package.seeall)
local util = require("moonscript.util")
local data = require("moonscript.data")
local insert = table.insert
manual_return = data.Set({
  "foreach",
  "for",
  "while",
  "return"
})
cascading = data.Set({
  "if",
  "with",
  "switch"
})
is_value = function(stm)
  local compile, transform = moonscript.compile, moonscript.transform
  return compile.Block:is_value(stm) or transform.Value:can_transform(stm)
end
comprehension_has_value = function(comp)
  return is_value(comp[2])
end
ntype = function(node)
  if type(node) ~= "table" then
    return "value"
  else
    return node[1]
  end
end
is_slice = function(node)
  return ntype(node) == "chain" and ntype(node[#node]) == "slice"
end
local t = { }
local node_types = {
  class = {
    {
      "name",
      "Tmp"
    },
    {
      "body",
      t
    }
  },
  fndef = {
    {
      "args",
      t
    },
    {
      "whitelist",
      t
    },
    {
      "arrow",
      "slim"
    },
    {
      "body",
      t
    }
  },
  foreach = {
    {
      "names",
      t
    },
    {
      "iter"
    },
    {
      "body",
      { }
    }
  },
  ["for"] = {
    {
      "name"
    },
    {
      "bounds",
      t
    },
    {
      "body",
      t
    }
  },
  assign = {
    {
      "names",
      t
    },
    {
      "values",
      t
    }
  },
  declare = {
    {
      "names",
      t
    }
  },
  ["if"] = {
    {
      "cond",
      t
    },
    {
      "then",
      t
    }
  }
}
local build_table
build_table = function()
  local key_table = { }
  for name, args in pairs(node_types) do
    local index = { }
    for i, tuple in ipairs(args) do
      local name = tuple[1]
      index[name] = i + 1
    end
    key_table[name] = index
  end
  return key_table
end
local key_table = build_table()
local make_builder
make_builder = function(name)
  local spec = node_types[name]
  if not spec then
    error("don't know how to build node: " .. name)
  end
  return function(props)
    if props == nil then
      props = { }
    end
    local node = {
      name
    }
    for i, arg in ipairs(spec) do
      local key, default_value = unpack(arg)
      local val
      if props[key] then
        val = props[key]
      else
        val = default_value
      end
      if val == t then
        val = { }
      end
      node[i + 1] = val
    end
    return node
  end
end
build = nil
build = setmetatable({
  group = function(body)
    return {
      "group",
      body
    }
  end,
  ["do"] = function(body)
    return {
      "do",
      body
    }
  end,
  assign_one = function(name, value)
    return build.assign({
      names = {
        name
      },
      values = {
        value
      }
    })
  end,
  table = function(tbl)
    if tbl == nil then
      tbl = { }
    end
    return {
      "table",
      tbl
    }
  end,
  block_exp = function(body)
    return {
      "block_exp",
      body
    }
  end,
  chain = function(parts)
    local base = parts.base or error("expecting base property for chain")
    local node = {
      "chain",
      base
    }
    local _list_0 = parts
    for _index_0 = 1, #_list_0 do
      local part = _list_0[_index_0]
      insert(node, part)
    end
    return node
  end
}, {
  __index = function(self, name)
    self[name] = make_builder(name)
    return rawget(self, name)
  end
})
smart_node = function(node)
  local index = key_table[ntype(node)]
  if not index then
    return node
  end
  return setmetatable(node, {
    __index = function(node, key)
      if index[key] then
        return rawget(node, index[key])
      elseif type(key) == "string" then
        return error("unknown key: `" .. key .. "` on node type: `" .. ntype(node) .. "`")
      end
    end,
    __newindex = function(node, key, value)
      if index[key] then
        key = index[key]
      end
      return rawset(node, key, value)
    end
  })
end
