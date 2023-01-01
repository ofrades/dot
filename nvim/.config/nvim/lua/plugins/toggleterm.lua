return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 20
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.3
				end
			end,
			start_in_insert = false,
			open_mapping = [[<c-\>]],
			direction = "float",
		})
	end,
}
