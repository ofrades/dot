return {
	{ "echasnovski/mini.pairs", enabled = false },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
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
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["mdx"] = { { "prettier" } },
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{ "<leader>k", "<cmd>:lua require'telescope.builtin'.grep_string()<CR>", mode = { "n", "x" } },
			{ "<leader>gc", "<cmd>:lua require'telescope.builtin'.git_bcommits()<CR>", mode = { "n", "x" } },
			-- {
			-- 	"-",
			-- 	":Telescope file_browser path=%:p:h select_buffer=true initial_mode=normal<CR>",
			-- 	mode = { "n", "x" },
			-- },
		},
		opts = {
			defaults = require("telescope.themes").get_ivy({
				wrap_results = true,
				winblend = 10,
				width = 1,
				show_line = true,
				previewer = true,
				initial_mode = "normal",
			}),
		},
	},
	{
		"numToStr/Navigator.nvim",
		lazy = true,
		config = function()
			require("Navigator").setup({
				auto_save = "current",
			})
		end,
		keys = {
			{ "<C-h>", "<CMD>NavigatorLeft<CR>" },
			{ "<C-l>", "<CMD>NavigatorRight<CR>" },
			{ "<C-k>", "<CMD>NavigatorUp<CR>" },
			{ "<C-j>", "<CMD>NavigatorDown<CR>" },
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-vim-test",
		},
		opts = {
			adapters = {
				["neotest-vitest"] = {},
				-- ["neotest-vim-test"] = {
				-- 	ignore_file_types = { "typescriptreact", "typescript" },
				-- },
				-- ["neotest-vim-test"] = {},
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
