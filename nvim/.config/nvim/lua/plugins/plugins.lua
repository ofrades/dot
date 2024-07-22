return {
	{ "echasnovski/mini.pairs", enabled = false },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "mg979/vim-visual-multi" },
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
			},
		},
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory with Oil" },
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
		},
		opts = {
			adapters = {
				["neotest-vitest"] = {},
			},
			output = {
				enabled = false,
			},
			quickfix = {
				enabled = false,
			},
		},
	},
}
