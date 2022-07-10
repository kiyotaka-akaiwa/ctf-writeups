local toRect = require(script.Parent.toRect)
local returnValue = require(script.Parent.returnValue)

return function(a, b, distance)
	local aRect = toRect(a)
	local bRect = toRect(b)

	local distanceFromSide = aRect.Min - bRect.Max
	if distance then
		if typeof(distance) == "number" then
			distance = NumberRange.new(distance)
		end

		return returnValue(
			distance.Min <= distanceFromSide.Y and distance.Max >= distanceFromSide.Y,
			"Was within range",
			"Was not within range ( " .. tostring(distance) .. ")"
		)
	else
		return returnValue(
			distanceFromSide.Y >= 0,
			"Was below the element",
			"Was above the element"
		)
	end
end
