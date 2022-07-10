local AppStorageService = game:GetService("AppStorageService")

game:DefineFastInt("RoactNavigationMigrateTo0_5_2Rollout", 0)
game:DefineFastFlag("RoactNavigationMigrateTo0_5_2", false)

return function()
	local rolloutPercent = game:GetFastInt("RoactNavigationMigrateTo0_5_2Rollout")

	-- For testing, we want need an FFlag, as FInts aren't supported in the --ff allOn case
	if game:GetFastFlag("RoactNavigationMigrateTo0_5_2") then
		return true
	end

	if rolloutPercent <= 0 then
		return false
	end

	local appInstallationId = AppStorageService:GetItem("AppInstallationId")

	-- the AppInstallationID should be a string
	if typeof(appInstallationId) == "string" then
		if string.len(appInstallationId) <= 0 then
			return rolloutPercent >= 100
		end

		local installationNumber = tonumber(string.sub(appInstallationId, -2))
		if installationNumber == nil then
			return rolloutPercent >= 100
		end

		return (installationNumber :: number + 1) <= rolloutPercent
	end

	return rolloutPercent >= 100
end
