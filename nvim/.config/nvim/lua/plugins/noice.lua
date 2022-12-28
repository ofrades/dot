return {
	"folke/noice.nvim",
	config = function()
		require("noice").setup()
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				local notify = require("notify")
				notify.setup({
					render = "minimal",
					stages = "static",
					timeout = 1000,
				})
			end,
		},
	},
}
