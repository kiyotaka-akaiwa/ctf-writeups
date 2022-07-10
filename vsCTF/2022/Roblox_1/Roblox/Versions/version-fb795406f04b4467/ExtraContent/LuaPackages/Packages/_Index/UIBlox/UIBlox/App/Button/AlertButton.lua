local Button = script.Parent
local App = Button.Parent
local UIBlox = App.Parent
local Packages = UIBlox.Parent

local Roact = require(Packages.Roact)
local Cryo = require(Packages.Cryo)
local RoactGamepad = require(Packages.RoactGamepad)

local Images = require(App.ImageSet.Images)
local CursorKind = require(App.SelectionImage.CursorKind)
local withSelectionCursorProvider = require(App.SelectionImage.withSelectionCursorProvider)

local validateButtonProps = require(Button.validateButtonProps)
local GenericButton = require(UIBlox.Core.Button.GenericButton)
local ControlState = require(UIBlox.Core.Control.Enum.ControlState)

local AlertButton = Roact.PureComponent:extend("AlertButton")

local BUTTON_STATE_COLOR = {
	[ControlState.Default] = "Alert",
}

local CONTENT_STATE_COLOR = {
	[ControlState.Default] = "Alert",
}

AlertButton.defaultProps = {
	isDisabled = false,
	isLoading = false,
}

function AlertButton:render()
	assert(validateButtonProps(self.props))
	local image = Images["component_assets/circle_17_stroke_1"]
	return withSelectionCursorProvider(function(getSelectionCursor)
		return Roact.createElement(RoactGamepad.Focusable[GenericButton], {
			Size = self.props.size,
			AnchorPoint = self.props.anchorPoint,
			Position = self.props.position,
			LayoutOrder = self.props.layoutOrder,
			SelectionImageObject = getSelectionCursor(CursorKind.RoundedRectNoInset),
			icon = self.props.icon,
			text = self.props.text,
			inputIcon = self.props.inputIcon,
			fontStyle = self.props.fontStyle,
			isDisabled = self.props.isDisabled,
			isLoading = self.props.isLoading,
			onActivated = self.props.onActivated,
			onStateChanged = self.props.onStateChanged,
			userInteractionEnabled = self.props.userInteractionEnabled,
			buttonImage = image,
			buttonStateColorMap = BUTTON_STATE_COLOR,
			contentStateColorMap = CONTENT_STATE_COLOR,

			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown,
			NextSelectionLeft = self.props.NextSelectionLeft,
			NextSelectionRight = self.props.NextSelectionRight,
			[Roact.Ref] = self.props.buttonRef,
		})
	end)
end

return Roact.forwardRef(function(props, ref)
	return Roact.createElement(AlertButton, Cryo.Dictionary.join(props, {
		buttonRef = ref
	}))
end)
