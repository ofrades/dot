return {
	"gbprod/yanky.nvim",
	config = function()
		require("yanky").setup({
			ring = {
				history_length = 100,
				storage = "shada",
				sync_with_numbered_registers = true,
				cancel_event = "update",
			},
			highlight = {
				timer = 100,
			},
			system_clipboard = {
				sync_with_ring = true,
			},
		})
	end,
}
