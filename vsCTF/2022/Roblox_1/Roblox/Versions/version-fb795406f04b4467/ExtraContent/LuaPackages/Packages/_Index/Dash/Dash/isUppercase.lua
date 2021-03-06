--[[
	Returns `true` if the first character of _input_ is an upper-case character.

	Throws if the _input_ is not a string or it is the empty string.

	Our current version of Lua unfortunately does not support upper or lower-case detection outside
	the english alphabet. This function has been implemented to return the expected result once
	this has been corrected.
]]
local Dash = script.Parent
local assertEqual = require(Dash.assertEqual)

local function isUppercase(input: string)
	assertEqual(typeof(input), "string", [[Attempted to call Dash.isUppercase with argument #1 of type {left:?} not {right:?}]])
	assertEqual(#input > 0, true, [[Attempted to call Dash.isUppercase with an empty string]])
	local firstLetter = input:sub(1, 1)
	return firstLetter == firstLetter:upper()
end
return isUppercase