
-- insert all moon library functions into requiring scope

export moon
moon = rawget(_G, "moon") or {}
moon.inject = true
require "moon.init"

