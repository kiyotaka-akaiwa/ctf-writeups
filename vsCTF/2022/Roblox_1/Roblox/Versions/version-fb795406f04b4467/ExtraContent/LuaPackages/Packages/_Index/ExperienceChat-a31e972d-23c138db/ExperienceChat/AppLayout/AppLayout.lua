local ExperienceChat = script:FindFirstAncestor("ExperienceChat")
local ProjectRoot = ExperienceChat.Parent

local Otter = require(ProjectRoot.Otter)
local Roact = require(ProjectRoot.Roact)

local ChatInputBar = require(ExperienceChat.ChatInput)
local ChatWindow = require(ExperienceChat.ChatWindow)
local Config = require(ExperienceChat.Config)
local Timer = require(ExperienceChat.Timer)

local AppLayout = Roact.Component:extend("AppLayout")
AppLayout.defaultProps = {
	addTopPadding = true,
	canLocalUserChat = false,
	isChatInputBarVisible = true,
	isChatWindowVisible = true,
	LayoutOrder = 1,
	mutedUserIds = nil,
	onSendChat = nil,
	textTimer = Timer.new(Config.ChatWindowTextFadeOutTime),
	timer = Timer.new(Config.ChatWindowBackgroundFadeOutTime),
}

local SPRING_PARAMS = {
	frequency = 1.25,
	dampingRatio = 1,
}

function AppLayout:init()
	self.isChatWindowHovered = false
	self.isChatInputBarHoveredOrFocused = false

	self.transparencyValue, self.updateBackgroundTransparency = Roact.createBinding(0)
	self.backgroundTransparencyMotor = Otter.createSingleMotor(0)
	self.backgroundTransparencyMotor:onStep(self.updateBackgroundTransparency)

	self.textTransparencyValue, self.updateTextTransparencyValue = Roact.createBinding(0)
	self.textTransparencyMotor = Otter.createSingleMotor(0)
	self.textTransparencyMotor:onStep(self.updateTextTransparencyValue)

	self.fadeIn = function()
		self.backgroundTransparencyMotor:setGoal(Otter.instant(0))
		self.props.timer:stop()

		self.textTransparencyMotor:setGoal(Otter.instant(0))
		self.props.textTimer:stop()
	end

	self.fadeOut = function()
		self.props.timer:start():andThen(function()
			self.backgroundTransparencyMotor:setGoal(Otter.spring(1, SPRING_PARAMS))
		end)

		self.props.textTimer:start():andThen(function()
			self.textTransparencyMotor:setGoal(Otter.spring(1, SPRING_PARAMS))
		end)
	end

	self.resetTextTransparency = function()
		-- Restart the timer
		self.textTransparencyMotor:setGoal(Otter.instant(0))
		self.props.textTimer:stop()
		self.props.textTimer:start():andThen(function()
			self.textTransparencyMotor:setGoal(Otter.spring(1, SPRING_PARAMS))
		end)
	end

	self.performFading = function()
		if self.isChatWindowHovered or self.isChatInputBarHoveredOrFocused then
			self.fadeIn()
		else
			self.fadeOut()
		end
	end

	self.onChatWindowHovered = function()
		self.isChatWindowHovered = true
		self.performFading()
	end

	self.onChatWindowNotHovered = function()
		self.isChatWindowHovered = false
		self.performFading()
	end

	self.onChatInputBarHoveredOrFocused = function()
		self.isChatInputBarHoveredOrFocused = true
		self.performFading()
	end

	self.onChatInputBarNotHoveredOrFocused = function()
		self.isChatInputBarHoveredOrFocused = false
		self.performFading()
	end
end

function AppLayout:didMount()
	self.props.timer:start():andThen(function()
		self.backgroundTransparencyMotor:setGoal(Otter.spring(1, SPRING_PARAMS))
	end)

	self.props.textTimer:start():andThen(function()
		self.textTransparencyMotor:setGoal(Otter.spring(1, SPRING_PARAMS))
	end)
end

function AppLayout:didUpdate(previousProps, _)
	if
		not (self.isChatWindowHovered or self.isChatInputBarHoveredOrFocused)
		and previousProps.messages ~= self.props.messages
	then
		self.resetTextTransparency()
	end
end

function AppLayout:render()
	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Position = Config.ChatWindowPosition,
		Size = Config.ChatWindowSize,
	}, {
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		topBorder = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
			ImageColor3 = Config.ChatWindowBackgroundColor3,
			ImageTransparency = self.transparencyValue:map(function(value)
				local initialTransparency = Config.ChatWindowBackgroundTransparency
				return initialTransparency + value * (1 - initialTransparency)
			end),
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 8),
			SliceCenter = Rect.new(8, 8, 24, 32),
			Visible = self.props.isChatWindowVisible or self.props.isChatInputBarVisible,
			[Roact.Event.MouseEnter] = self.onChatWindowHovered,
			[Roact.Event.MouseLeave] = self.onChatWindowNotHovered,
		}, {
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(Config.ChatWindowMaxWidth, math.huge),
			}),
		}),
		chatWindow = self.props.isChatWindowVisible and Roact.createElement(ChatWindow, {
			LayoutOrder = 2,
			size = UDim2.fromScale(1, 1),
			transparencyValue = self.transparencyValue,
			textTransparency = self.textTransparencyValue,
			onChatWindowHovered = self.onChatWindowHovered,
			onChatWindowNotHovered = self.onChatWindowNotHovered,
			mutedUserIds = self.props.mutedUserIds,
			canLocalUserChat = self.props.canLocalUserChat,
		}),
		chatInputBar = self.props.isChatInputBarVisible and Roact.createElement(ChatInputBar, {
			LayoutOrder = 3,
			addTopPadding = self.props.isChatWindowVisible,
			onSendChat = self.props.onSendChat,
			transparencyValue = self.transparencyValue,
			onChatInputBarHoveredOrFocused = self.onChatInputBarHoveredOrFocused,
			onChatInputBarNotHoveredOrFocused = self.onChatInputBarNotHoveredOrFocused,
			canLocalUserChat = self.props.canLocalUserChat,
		}),
		bottomBorder = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
			ImageColor3 = Config.ChatWindowBackgroundColor3,
			ImageTransparency = self.transparencyValue:map(function(value)
				local initialTransparency = Config.ChatWindowBackgroundTransparency
				return initialTransparency + value * (1 - initialTransparency)
			end),
			LayoutOrder = 4,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 8),
			SliceCenter = Rect.new(8, 0, 24, 16),
			Visible = self.props.isChatWindowVisible or self.props.isChatInputBarVisible,
			[Roact.Event.MouseEnter] = self.onChatWindowHovered,
			[Roact.Event.MouseLeave] = self.onChatWindowNotHovered,
		}, {
			uiSizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(Config.ChatWindowMaxWidth, math.huge),
			}),
		}),
	})
end

return AppLayout
