--[[
	A component that establishes a connection to a Roblox event when it is rendered.
]]

local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

-- local ExternalEventConnection = dependencies.ExternalEventConnection
local Roact = dependencies.Roact
local ExternalEventConnection = Roact.Component:extend("ExternalEventConnection")

function ExternalEventConnection:init()
	self.connection = nil
end

--[[
	Render the child component so that ExternalEventConnections can be nested like so:

		Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputBegan,
			callback = inputBeganCallback,
		}, {
			Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = inputChangedCallback,
			})
		})
]]
function ExternalEventConnection:render()
	return Roact.oneChild(self.props[Roact.Children])
end

function ExternalEventConnection:didMount()
	local event = self.props.event
	local callback = self.props.callback

	self.connection = event:Connect(callback)
end

function ExternalEventConnection:didUpdate(oldProps)
	if self.props.event ~= oldProps.event or self.props.callback ~= oldProps.callback then
		self.connection:Disconnect()

		self.connection = self.props.event:Connect(self.props.callback)
	end
end

function ExternalEventConnection:willUnmount()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return ExternalEventConnection
