local ExperienceChat = script:FindFirstAncestor("ExperienceChat")
local Packages = ExperienceChat.Parent
local globals = require(Packages.Dev.Jest).Globals
local expect = globals.expect

return function()
	beforeAll(function(c)
		expect.extend(require(Packages.Dev.CollisionMatchers).Jest)

		c.Roact = require(Packages.Roact)
		c.Rodux = require(Packages.Rodux)
		c.RoactRodux = require(Packages.RoactRodux)
		c.Rhodium = require(Packages.Dev.Rhodium)
		c.storyMiddleware = require(
			Packages:FindFirstChild("ExperienceChat.storybook"):FindFirstChild("storyMiddleware")
		)
		c.findFirstInstance = require(script.Parent.TestUtilities.findFirstInstance)
		c.makeTree = function(context, story, createProps)
			local Roact = context.Roact
			local storyMiddleware = context.storyMiddleware
			return Roact.createElement(storyMiddleware(story), createProps(context))
		end
		c.createMount = function(story, createProps)
			return function(context)
				local Roact = context.Roact
				local instance = Instance.new("ScreenGui")
				instance.Parent = game:GetService("CoreGui")

				local tree = context:makeTree(story, createProps)
				local roactInstance = Roact.mount(tree, instance)
				return {
					roactInstance = roactInstance,
					instance = instance,
					unmount = function()
						Roact.unmount(roactInstance)
						instance:Destroy()
					end,
				}
			end
		end
	end)

	it("should require all ModuleScripts", function()
		for _, child in ipairs(Packages:GetChildren()) do
			if child:IsA("ModuleScript") then
				require(child)
			end
		end
	end)

	it("should return a table", function()
		local src = require(script.Parent)
		expect(type(src)).toEqual("table")

		it("SHOULD have the expected fields", function()
			expect(src.ChatVisibility).never.toBeNil()
			expect(src.mountClientApp).never.toBeNil()
			expect(src.mountServerApp).never.toBeNil()
		end)
	end)
end
