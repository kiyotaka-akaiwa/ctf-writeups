local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.AppTempCommon.LuaApp.Http.Url)

--[[
	Documentation of endpoint:
	https://voice.roblox.com/docs#!/Voice/get_v1_settings_verify_show_age_verification_overlay_universeId
]]

return function(requestImpl, universeId, placeId)
	assert(type(placeId) == "string", "GetShowAgeVerificationOverlay request expects placeId to be a string")
	assert(type(universeId) == "string", "GetShowAgeVerificationOverlay request expects universeId to be a string")
	
	local url = string.format("%s/v1/settings/verify/show-age-verification-overlay/%s?placeId=%s", Url.VOICE_URL, universeId, placeId)

	return requestImpl(url, "GET")
end
