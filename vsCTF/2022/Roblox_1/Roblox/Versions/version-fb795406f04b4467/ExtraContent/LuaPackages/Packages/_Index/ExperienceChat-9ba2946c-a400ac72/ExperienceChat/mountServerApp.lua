--!strict
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local TextChatService = game:GetService("TextChatService")

local ExperienceChat = script:FindFirstAncestor("ExperienceChat")
local Packages = ExperienceChat.Parent
local List = require(Packages.llama).List

local countParticipantsInTextChannel = require(ExperienceChat.countParticipantsInTextChannel)

local CommandTypes = require(ExperienceChat.Commands.types)
type Command = CommandTypes.Command
local Commands = require(ExperienceChat.Commands)
local Config = require(ExperienceChat.Config)

local Analytics = require(ExperienceChat.Analytics)
local Logger = require(ExperienceChat.Logger):new("ExpChat/" .. script.Name)

type Config = {
	analytics: any?,
}

return function(config: Config)
	Logger:trace("mountServerApp started")

	if config and config.analytics then
		Analytics.with(config.analytics)
	end

	local loadedChannels = List.map(TextChatService:GetDescendants(), function(instance: Instance)
		return instance:IsA("TextChannel")
	end)

	local loadedCommands = List.map(TextChatService:GetDescendants(), function(instance: Instance)
		return instance:IsA("TextChatCommand")
	end)

	local defaultChannels = {}

	if TextChatService.CreateDefaultTextChannels then
		Logger:trace("Creating default TextChannels")

		local textChannelsFolder = Instance.new("Folder")
		textChannelsFolder.Name = "TextChannels"
		textChannelsFolder.Parent = TextChatService

		local function findChannel(channelName)
			for _, descendant in pairs(TextChatService:GetDescendants()) do
				if descendant:IsA("TextChannel") and descendant.Name == channelName then
					return descendant
				end
			end

			return nil
		end

		local function addChannel(channelName)
			local channel = findChannel(channelName)

			if not channel then
				channel = Instance.new("TextChannel")
				channel.Name = channelName
				channel.Parent = textChannelsFolder
			end

			return channel
		end

		local function findTextSourceFromChannelWithUserId(channel, userId): TextSource?
			for _, child: Instance in pairs(channel:GetChildren()) do
				if child:IsA("TextSource") and child.UserId == userId then
					return child
				end
			end

			return nil
		end

		local function createTeamChannel(team: Team)
			local channel = addChannel("RBXTeam" .. tostring(team.TeamColor.Name))
			Logger:debug("Creating team TextChannel: {}", channel.Name)

			team.PlayerAdded:Connect(function(player)
				local textSource = channel:AddUserAsync(player.UserId)
				textSource.CanSend = true
			end)

			team.PlayerRemoved:Connect(function(player)
				local textSource = findTextSourceFromChannelWithUserId(channel, player.UserId)
				if textSource then
					textSource:Destroy()
				end
			end)

			-- when a team color changes, everyone in that team is kicked off
			-- in the unlikely case a developer tries to then reuse this team, the associated team TextChannel should
			-- also be reused, with corresponding name change
			team:GetPropertyChangedSignal("TeamColor"):Connect(function()
				channel.Name = "RBXTeam" .. tostring(team.TeamColor.Name)
			end)
		end

		for _, team in pairs(Teams:GetTeams()) do
			if team:IsA("Team") then
				createTeamChannel(team)
			end
		end

		Teams.ChildAdded:Connect(function(child)
			if child:IsA("Team") then
				createTeamChannel(child)
			end
		end)

		Teams.ChildRemoved:Connect(function(child)
			if child:IsA("Team") then
				local textChannel = findChannel("RBXTeam" .. tostring(child.TeamColor.Name))
				if textChannel then
					Logger:debug("Destroying team TextChannel: {}", textChannel.Name)
					textChannel:Destroy()
				end
			end
		end)

		for channelName, _ in pairs(Config.DefaultChannelNames) do
			Logger:trace("Creating default channel: {}", channelName)
			table.insert(defaultChannels, addChannel(channelName))
		end

		local function addPlayerTextSourceToDefaultChannels(player: Player)
			for _, channel in ipairs(defaultChannels) do
				local textSource = channel:AddUserAsync(player.UserId)
				if channel.Name == "RBXGeneral" then
					textSource.CanSend = true
				elseif channel.Name == "RBXSystem" then
					textSource.CanSend = false
				end
			end
		end

		for _, player in pairs(Players:GetPlayers()) do
			if player:IsA("Player") then
				addPlayerTextSourceToDefaultChannels(player)
			end
		end

		Players.PlayerAdded:Connect(addPlayerTextSourceToDefaultChannels)

		Analytics.FireRccAnalyticsWithEventName("DefaultChannelsCreated")
	end

	if TextChatService.CreateDefaultCommands then
		Logger:trace("Creating default TextChatCommands")
		local textChatCommandsFolder = Instance.new("Folder")
		textChatCommandsFolder.Name = "TextChatCommands"
		textChatCommandsFolder.Parent = TextChatService

		for _, command in ipairs(Commands) do
			local textChatCommand = Instance.new("TextChatCommand")
			textChatCommand.Name = command.name
			textChatCommand.PrimaryAlias = command.alias[1]
			textChatCommand.SecondaryAlias = command.alias[2] or ""
			textChatCommand.Parent = textChatCommandsFolder
		end

		Analytics.FireRccAnalyticsWithEventName("DefaultCommandsCreated")
	end

	Analytics.FireRccAnalyticsWithEventName("ExperienceChatLoaded", {
		loadedChannels = loadedChannels,
		loadedCommands = loadedCommands,
	})

	Logger:debug("Start watching for new channels and commands")

	local totalChannels = #loadedChannels + #defaultChannels
	TextChatService.DescendantAdded:Connect(function(instance)
		if instance:IsA("TextChannel") then
			totalChannels += 1
			Analytics.FireRccAnalyticsWithEventName("ChannelCreated", {
				channelName = instance.Name,
				totalChannels = totalChannels,
			})
		elseif instance:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandCreated", {
				commandName = instance.Name,
			})
		elseif instance:IsA("TextSource") then
			local textChannel = instance.Parent
			if textChannel and textChannel:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelJoined", {
					channelName = textChannel.Name,
					totalParticipants = countParticipantsInTextChannel(textChannel),
				})
			end
		end
	end)

	TextChatService.DescendantRemoving:Connect(function(instance)
		if instance:IsA("TextChannel") then
			totalChannels -= 1
			Analytics.FireRccAnalyticsWithEventName("ChannelRemoved", {
				channelName = instance.Name,
				totalChannels = totalChannels,
			})
		elseif instance:IsA("TextChatCommand") then
			Analytics.FireRccAnalyticsWithEventName("CommandRemoved", {
				commandName = instance.Name,
			})
		elseif instance:IsA("TextSource") then
			local textChannel = instance.Parent
			if textChannel and textChannel:IsA("TextChannel") then
				Analytics.FireRccAnalyticsWithEventName("ChannelLeft", {
					channelName = textChannel.Name,
					totalParticipants = countParticipantsInTextChannel(textChannel),
				})
			end
		end
	end)
end
