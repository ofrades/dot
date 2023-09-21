return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "echasnovski/mini.pairs", enabled = false },
	{
		"nyoom-engineering/oxocarbon.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader>k", "<cmd>:lua require'telescope.builtin'.grep_string()<CR>", mode = { "n", "x" } },
		},
	},
	{ "mg979/vim-visual-multi", lazy = false },
	{
		"folke/edgy.nvim",
		opts = {
			top = {
				{
					title = "Neo-Tree",
					ft = "neo-tree",
					size = { height = 0.3 },
				},
			},
		},
	},
	{
		"folke/drop.nvim",
		config = function()
			require("drop").setup({
				theme = "summer",
			})
		end,
	},
	{ "simnalamburt/vim-mundo" },
	{
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require("refactoring").setup({})
		end,
	},
	{
		"echasnovski/mini.files",
		opts = {
			windows = {
				-- preview = false,
				-- width_focus = 100,
				-- width_nofocus = 50,
				-- width_preview = 100,
			},
			mappings = {
				go_in = "L",
				go_in_plus = "l",
			},
		},
		keys = {
			{
				"-",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (directory of current file)",
			},
		},
	},
	{
		"nvim-pack/nvim-spectre",
		keys = {
			{
				"<leader>sp",
				"<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
				desc = "Search current word",
				mode = "n",
			},
			{
				"<leader>sp",
				"<esc><cmd>lua require('spectre').open_visual()<CR>",
				desc = "Search current word",
				mode = "v",
			},
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
		"uga-rosa/ccc.nvim",
		opts = function()
			require("ccc").setup({
				highlighter = {
					auto_enable = true,
				},
			})
		end,
	},
	{ "kevinhwang91/nvim-bqf" },
	{ "vim-test/vim-test" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
		},
		opts = {
			adapters = { "neotest-vitest" },
			output = {
				enabled = false,
			},
			quickfix = {
				enabled = false,
			},
			consumers = {
				custom = function(client)
					-- Custom hook to open the output panel after test results that fail, and auto-focus the panel and jump to its bottom
					client.listeners.results = function(_, results)
						local any_failed = false
						for _, result in pairs(results) do
							if result.status == "failed" then
								any_failed = true
								break
							end
						end

						if any_failed then
							local win = vim.fn.bufwinid("Neotest OutputPanel")
							if win > -1 then
								vim.api.nvim_set_current_win(win)
								vim.cmd("$") -- Jump to end
							else
								require("neotest").output_panel.open()
							end
						else
							require("neotest").output_panel.close()
						end
					end
				end,
			},
		},
	},
}
