return function()
	local AppsFlyerUtil = require(script.Parent.AppsFlyerUtil)

	describe("AppsFlyerUtil", function()
		describe("replaceNewlines", function()
			it("should replace newlines", function()
				local str = "windows\r\nand\nlinux\r\nnewlines\nare so cool!"
				expect(AppsFlyerUtil.replaceNewlines(str)).to.equal(
					"windows and linux newlines are so cool!"
				)
			end)

			it("should work with a specific replacement", function()
				local str = "windows\r\nand\nlinux newlines"
				expect(AppsFlyerUtil.replaceNewlines(str, "!!")).to.equal(
					"windows!!and!!linux newlines"
				)
			end)
		end)

		describe("truncateLength", function()
			it("should work with the default argument of 140", function()
				-- 137 a's
				local longString = string.rep("a", 137)

				expect(
					AppsFlyerUtil.truncateLength(longString)
				).to.equal(longString)

				expect(
					AppsFlyerUtil.truncateLength(longString .. "aaa")
				).to.equal(longString .. "aaa")

				expect(
					AppsFlyerUtil.truncateLength(longString .. "aaaa")
				).to.equal(longString .. "...")
			end)

			it("should return strings lessΒ than or equal the length", function()
				expect(
					AppsFlyerUtil.truncateLength("0123456", 10)
				).to.equal("0123456")

				expect(
					AppsFlyerUtil.truncateLength("0123456789", 10)
				).to.equal("0123456789")
			end)

			it("should truncate ascii with no spaces", function()
				expect(
					AppsFlyerUtil.truncateLength("01234567890", 10)
				).to.equal("0123456...")
			end)

			it("should truncate with spaces", function()
				expect(
					AppsFlyerUtil.truncateLength("012 45 67890", 10)
				).to.equal("012 45...")
			end)

			it("should truncate with emojis", function()
				expect(
					AppsFlyerUtil.truncateLength("π π cool", 10)
				).to.equal("π...")

				expect(
					AppsFlyerUtil.truncateLength("πππ", 11)
				).to.equal("ππ...")

				expect(
					AppsFlyerUtil.truncateLength("πππ", 12)
				).to.equal("πππ")
			end)
		end)

		describe("sanitizeDescription", function()
			it("should truncate new lines and work with emojis", function()
				local longDescription = "π’ UPDATE: World 31 is out! β\r\n"
					.. "π LIKE IF YOU WANT MORE UPDATES!\r\n"
					.. "\r\n"
					.. "FEATURES:\r\n"
					.. "π Experience the busy life of a bee!\r\n"
					.. "π― Collect pollen, turn it into honey and expand your plot!\r\n"
					.. "πΈ Thousands of flowers await you!\r\n"
					.. "π Show your skills and become the Queen Bee!\r\n"
					.. "\r\n"
					.. "Please join our group to stay tuned π https://www.roblox.com/groups/7083660/StealthWhale"
				expect(
					AppsFlyerUtil.sanitizeDescription(longDescription)
				).to.equal("π’ UPDATE: World 31 is out! β π LIKE IF YOU WANT MORE UPDATES!  FEATURES: π Experience the busy life of a bee! π― Collect...")
			end)
		end)
	end)
end
