local UserInputService = game:GetService("UserInputService")

local MediaGallery = script.Parent
local Container = MediaGallery.Parent
local App = Container.Parent
local UIBlox = App.Parent
local Packages = UIBlox.Parent

local Roact = require(Packages.Roact)
local t = require(Packages.t)
local Images = require(App.ImageSet.Images)
local IconButton = require(App.Button.IconButton)
local ExternalEventConnection = require(UIBlox.Utility.ExternalEventConnection)
local withStyle = require(UIBlox.Core.Style.withStyle)

local ThumbnailButton = require(MediaGallery.ThumbnailButton)
local getShowItems = require(MediaGallery.getShowItems)

local ICON_CYCLE_LEFT = "icons/actions/cycleLeft"
local ICON_CYCLE_RIGHT = "icons/actions/cycleRight"
local IMAGE_RATIO = 16 / 9 -- width / height
local ARROW_WIDTH = 96

local FullScreen = Roact.Component:extend("FullScreen")

FullScreen.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),

	items = t.array(t.interface({
		imageId = t.string,
		isVideo = t.optional(t.boolean),
	})),
	showIndex = t.optional(t.integer),
	onVideoPlayActivated = t.optional(t.callback),
})

FullScreen.defaultProps = {
	size = UDim2.fromScale(1, 1),
	showIndex = 1,
}

function FullScreen.getDerivedStateFromProps(nextProps, lastState)
	local nextState

	if lastState.items ~= nextProps.items then
		local itemsToShow = getShowItems(nextProps)

		nextState = {
			items = nextProps.items,
			itemsToShow = itemsToShow,
			showArrows = #itemsToShow > 1,
			focusIndex = math.min(lastState.focusIndex or 1, #itemsToShow),
		}
	end

	if lastState.showIndex ~= nextProps.showIndex then
		nextState = nextState or {}
		nextState.showIndex = nextProps.showIndex
		nextState.focusIndex = math.min(nextProps.showIndex, #nextProps.items)
	end

	return nextState
end

function FullScreen:init()
	self.state = {
		items = nil,
		itemsToShow = nil,
		showArrows = true,
		focusIndex = 1,
		showIndex = 1,
	}

	self.itemFrameSize, self.updateItemFrameSize = Roact.createBinding(UDim2.fromScale(1, 1))

	self.onResize = function(container)
		local containerWidth = container.AbsoluteSize.X
		local containerHeight = container.AbsoluteSize.Y

		local itemFrameHeight = containerHeight
		local itemFrameWidth = math.floor(itemFrameHeight * IMAGE_RATIO)
		if itemFrameWidth > containerWidth then
			itemFrameWidth = containerWidth
			itemFrameHeight = math.floor(itemFrameWidth / IMAGE_RATIO)
		end

		self.updateItemFrameSize(UDim2.new(0, itemFrameWidth, 0, itemFrameHeight))
	end

	self.onUserInputBegan = function(input)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local focusIndex = self.state.focusIndex
		local itemsCount = #self.props.items

		if input.KeyCode == Enum.KeyCode.Left and focusIndex > 1 then
			self.showPreviousItem()
		elseif input.KeyCode == Enum.KeyCode.Right and focusIndex < itemsCount then
			self.showNextItem()
		end
	end

	self.showPreviousItem = function()
		local nextFocusIndex = self.state.focusIndex - 1
		if nextFocusIndex < 1 then
			nextFocusIndex = 1
		end

		self:setState({
			focusIndex = nextFocusIndex,
		})
	end

	self.showNextItem = function()
		local itemsCount = #self.props.items
		local nextFocusIndex = self.state.focusIndex + 1
		if nextFocusIndex > itemsCount then
			nextFocusIndex = itemsCount
		end

		self:setState({
			focusIndex = nextFocusIndex,
		})
	end

	self.onVideoPlayActivated = function(index)
		if self.props.onVideoPlayActivated then
			local itemsToShow = self.state.itemsToShow
			local originalIndex = itemsToShow[index].originalIndex

			self.props.onVideoPlayActivated(originalIndex)
		end
	end
end

function FullScreen:render()
	return withStyle(function(style)
		return self:renderWithProvider(style)
	end)
end

function FullScreen:renderWithProvider(style)
	local layoutOrder = self.props.layoutOrder
	local anchorPoint = self.props.anchorPoint
	local position = self.props.position
	local size = self.props.size

	local itemsToShow = self.state.itemsToShow
	local showArrows = self.state.showArrows
	local focusIndex = self.state.focusIndex

	local item = itemsToShow[focusIndex]
	local leftArrowDisabled = focusIndex <= 1
	local rightArrowDisabled = focusIndex >= #itemsToShow

	return Roact.createElement("Frame", {
		LayoutOrder = layoutOrder,
		Size = size,
		AnchorPoint = anchorPoint,
		Position = position,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		[Roact.Change.AbsoluteSize] = self.onResize,
	}, {
		ItemFrame = Roact.createElement("Frame", {
			Size = self.itemFrameSize,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
		}, {
			LeftArrow = showArrows and Roact.createElement("Frame", {
				Size = UDim2.new(0, ARROW_WIDTH, 1, 0),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.fromScale(0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 100,
			}, {
				LeftArrowButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(1, 1),
					icon = Images[ICON_CYCLE_LEFT],
					showBackground = true,
					backgroundColor = style.Theme.Overlay,
					isDisabled = leftArrowDisabled,
					onActivated = self.showPreviousItem,
				}),
			}) or nil,
			Item = Roact.createElement(ThumbnailButton, {
				itemKey = focusIndex,
				imageId = item.imageId,
				isVideo = item.isVideo,
				userInteractionEnabled = false,
				onPlayActivated = item.isVideo and self.onVideoPlayActivated or nil,
			}),
			RightArrow = showArrows and Roact.createElement("Frame", {
				Size = UDim2.new(0, ARROW_WIDTH, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ZIndex = 100,
			}, {
				RightArrowButton = Roact.createElement(IconButton, {
					size = UDim2.fromScale(1, 1),
					icon = Images[ICON_CYCLE_RIGHT],
					showBackground = true,
					backgroundColor = style.Theme.Overlay,
					isDisabled = rightArrowDisabled,
					onActivated = self.showNextItem,
				}),
			}) or nil,
		}),
		EventConnection = showArrows and Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputBegan,
			callback = self.onUserInputBegan,
		}) or nil,
	})
end

return FullScreen
