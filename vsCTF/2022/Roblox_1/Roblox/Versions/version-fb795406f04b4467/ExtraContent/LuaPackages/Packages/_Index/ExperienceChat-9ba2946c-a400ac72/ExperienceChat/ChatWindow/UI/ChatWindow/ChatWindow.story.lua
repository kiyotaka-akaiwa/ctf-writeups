local ProjectRoot = script:FindFirstAncestor("ExperienceChat").Parent
local Roact = require(ProjectRoot.Roact)

local ChatWindow = require(script.Parent)

return {
	summary = "ChatWindow concept with ScrollingView and TextMessageLabel. Currently children are static"
		.. " but in the future ChatWindow will parse text chat messages and convert into children.",
	story = function(props)
		return Roact.createElement(ChatWindow, {
			size = props.size,
			messages = props.messages,
			messageLimit = props.messageLimit,
			mutedUserIds = props.mutedUserIds,
			canLocalUserChat = props.canLocalUserChat,
		})
	end,
	controls = {},
	props = {
		canLocalUserChat = true,
		size = UDim2.fromOffset(350, 100),
		messages = {
			{
				prefixText = "Player1",
				text = "Hello world!",
				timestamp = DateTime.fromUnixTimestamp(1),
				userId = "1",
				status = Enum.TextChatMessageStatus.Success,
			},
			{
				prefixText = "<font color='#AA55AA'>Player2</font>",
				text = "Nice work.",
				timestamp = DateTime.fromUnixTimestamp(2),
				userId = "2",
				status = Enum.TextChatMessageStatus.Success,
			},
		},
	},
}
