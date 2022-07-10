local DetailsPage = script.Parent
local Template = DetailsPage.Parent
local App = Template.Parent
local UIBlox = App.Parent
local Packages = UIBlox.Parent

local withStyle = require(UIBlox.Core.Style.withStyle)
local ImageSetLabel = require(UIBlox.Core.ImageSet.ImageSetComponent).Label

local Images = require(UIBlox.App.ImageSet.Images)
local LoadableImage = require(App.Loading.LoadableImage)
local validateActionBarContentProps = require(App.Button.Validator.validateActionBarContentProps)
local ActionBar = require(App.Button.ActionBar)

local Constants = require(DetailsPage.Constants)

local Roact = require(Packages.Roact)
local t = require(Packages.t)

local DetailsPageTitleContent = require(DetailsPage.DetailsPageTitleContent)

local DROP_SHADOW_IMAGE = "component_assets/dropshadow_thumbnail_28"
local DROP_SHADOW_HEIGHT = 28

local DetailsPageHeader = Roact.PureComponent:extend("DetailsPageHeader")

local BOTTOM_MARGIN = 16
local INNER_PADDING = 16
local ITEM_PADDING = 24
local ImageHeight = {
	Desktop = 200,
	Mobile = 100,
}

local ACTIONBAR_WIDTH = 380
local ACTION_BAR_HEIGHT = 48

DetailsPageHeader.defaultProps = {
	thumbnailAspectRatio = Vector2.new(1, 1),
	isMobile = false,
}

DetailsPageHeader.validateProps = t.strictInterface({
	thumbnailImageUrl = t.optional(t.string),
	thumbnailAspectRatio = t.optional(t.Vector2),
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),

	actionBarProps = t.optional(validateActionBarContentProps),

	isMobile = t.optional(t.boolean),
})

function DetailsPageHeader:renderThumbnail(style, thumbnailWidth, thumbnailHeight)
	return Roact.createElement("Frame", {
		Size = UDim2.fromOffset(thumbnailWidth, thumbnailHeight),
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
	}, {
		ThumbnailTile = Roact.createElement(LoadableImage, {
			cornerRadius = UDim.new(0, 8),
			Size = UDim2.fromScale(1, 1),
			Image = self.props.thumbnailImageUrl,
		}),
		DropShadow = Roact.createElement(ImageSetLabel, {
			Size = UDim2.new(1, 0, 0, DROP_SHADOW_HEIGHT),
			Position = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			Image = Images[DROP_SHADOW_IMAGE],
			ImageColor3 = style.Theme.DropShadow.Color,
			ImageTransparency = style.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(32, 0, 33, 28),
		}),
	})
end

function DetailsPageHeader:renderDesktopMode(style)
	local thumbnailHeight = ImageHeight.Desktop
	local thumbnailWidth = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
	return {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Constants.SideMargin.Desktop),
			PaddingRight = UDim.new(0, Constants.SideMargin.Desktop),
			PaddingBottom = UDim.new(0, BOTTOM_MARGIN),
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, ITEM_PADDING),
		}),
		ThumbnailTileFrame = self:renderThumbnail(style, thumbnailWidth, thumbnailHeight),
		InfoFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, -(thumbnailWidth + Constants.SideMargin.Desktop * 2), 1, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
			TitleInfo = Roact.createElement(DetailsPageTitleContent, {
				titleText = self.props.titleText,
				subTitleText = self.props.subTitleText,
				renderInfoContent = self.props.renderInfoContent,
				verticalAlignment = Enum.VerticalAlignment.Top,
				layoutOrder = 1,
			}),
			Padding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, INNER_PADDING),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
			}),
			ActonBarFrame = Roact.createElement("Frame", {
				Size = UDim2.fromOffset(ACTIONBAR_WIDTH, ACTION_BAR_HEIGHT),
				BackgroundTransparency = 1,
				LayoutOrder = 3,
			}, {
				ActionBar = self.props.actionBarProps and Roact.createElement(ActionBar, {
					button = self.props.actionBarProps.button,
					icons = self.props.actionBarProps.icons,
					enableButtonAtStart = true,
					marginOverride = {
						left = 0,
						right = 0,
						top = 0,
						bottom = 0,
					},
					horizontalAlignment = Enum.HorizontalAlignment.Left,
				}) or nil,
			}),
		}),
	}
end

function DetailsPageHeader:renderisMobile(style)
	local thumbnailHeight = ImageHeight.Mobile
	local thumbnailWidth = thumbnailHeight * (self.props.thumbnailAspectRatio.X / self.props.thumbnailAspectRatio.Y)
	return {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Constants.SideMargin.Mobile),
			PaddingRight = UDim.new(0, Constants.SideMargin.Mobile),
			PaddingBottom = UDim.new(0, BOTTOM_MARGIN),
		}),
		ThumbnailTileFrame = self:renderThumbnail(style, thumbnailWidth, thumbnailHeight),
	}
end

function DetailsPageHeader:render()
	local isMobile = self.props.isMobile
	local displayMode = isMobile and "Mobile" or "Desktop"

	local backgroundBarHeight = Constants.HeaderBarBackgroundHeight[displayMode]
	local gradientHeight = (ImageHeight[displayMode] + BOTTOM_MARGIN) - backgroundBarHeight

	return withStyle(function(style)
		local theme = style.Theme

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}),
			GradientBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, gradientHeight),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				LayoutOrder = 1,
			}, {
				Gradient = Roact.createElement("UIGradient", {
					Rotation = 270,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.25),
						NumberSequenceKeypoint.new(1, 0.9999),
					}),
				}),
			}),
			BackgroundBar = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, backgroundBarHeight),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 2,
			}, isMobile and self:renderisMobile(style) or self:renderDesktopMode(style)),
		})
	end)
end

return DetailsPageHeader
