local UGCValidationService = game:GetService("UGCValidationService")

local root = script.Parent.Parent

local floatEquals = require(root.util.floatEquals)
local valueToString = require(root.util.valueToString)

local function validateMeshVertexColors(meshId: string): (boolean, {string}?)
	if meshId == "" then
		return false, { "Mesh must contain valid MeshId" }
	end

	local success, vertColors = pcall(function()
		return UGCValidationService:GetMeshVertColors(meshId)
	end)

	if not success then
		return false, { "Failed to load mesh data" }
	end

	for _, color in ipairs(vertColors) do
		if not floatEquals(color.R, 1) or not floatEquals(color.G, 1) or not floatEquals(color.B, 1) then
			return false, {
				string.format("Mesh cannot have non-neutral vertex colors. Found color: %s", valueToString(color))
			}
		end
	end

	return true
end

return validateMeshVertexColors
