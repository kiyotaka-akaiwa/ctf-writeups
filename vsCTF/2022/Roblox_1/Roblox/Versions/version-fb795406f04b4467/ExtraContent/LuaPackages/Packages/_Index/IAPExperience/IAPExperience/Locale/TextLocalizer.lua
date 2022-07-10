local Root = script.Parent.Parent

local Packages = Root.Parent
local Roact = require(Packages.Roact)
local t = require(Packages.t)

local LocaleService = require(Root.Locale.LocaleService)

local LocaleConsumer = require(script.Parent.LocaleConsumer)

local validateProps = t.strictInterface({
	locKey = t.string,
	params = t.optional(t.table),
	render = t.callback,
})

local function TextLocalizer(props)
	assert(validateProps(props))
	local locKey = props.locKey
	local params = props.params
	local render = props.render

	return Roact.createElement(LocaleConsumer, {
		render = function(localizationContext)
			return render(LocaleService.getString(localizationContext, locKey, params))
		end,
	})
end

return TextLocalizer
