-- ROBLOX upstream: no upstream
-- ROBLOX comment: mostly ported from https://github.com/browserify/node-util/blob/master/util.js
local Packages = script.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Number = LuauPolyfill.Number
local NaN = Number.NaN

local HttpService = game:GetService("HttpService")

local format = function(...): any
	local formatRegExp = "%%[sdj%%]"
	local i = 2
	local args = { ... }
	local f = args[1]
	local len = #args
	local ref = f:gsub(formatRegExp, function(x)
		if x == "%%" then
			return "%"
		end
		if i > len then
			return x
		end
		if x == "%s" then
			local returnValue
			if typeof(args[i]) == "function" then
				returnValue = "Function"
			else
				returnValue = tostring(args[i])
			end
			i = i + 1
			return returnValue
		elseif x == "%d" then
			local returnValue = tonumber(args[i]) or NaN
			i = i + 1
			return tostring(returnValue)
		elseif x == "%j" then
			local ok, result = pcall(function()
				local returnValue = HttpService:JSONEncode(args[i])
				i = i + 1
				return returnValue
			end)

			if not ok then
				i = i + 1
				return "[Circular]"
			end

			return result
		else
			return x
		end
	end)
	return ref
end
return format
