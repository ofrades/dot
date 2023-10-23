return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 150,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				background = {
					light = "latte",
					dark = "mocha",
				},
				color_overrides = {
					mocha = {
						rosewater = "#ffc6be",
						flamingo = "#fb4934",
						pink = "#ff75a0",
						mauve = "#f2594b",
						red = "#C42C2C",
						maroon = "#fe8019",
						peach = "#FFAD7D",
						yellow = "#fabd2f",
						green = "#98971a",
						teal = "#7bba7f",
						sky = "#7daea3",
						sapphire = "#689d6a",
						blue = "#80aa9e",
						lavender = "#FF9941",
						text = "#d2cca9",
						subtext1 = "#c2cca9",
						subtext0 = "#b2cca9",
						overlay2 = "#8C7A58",
						overlay1 = "#735F3F",
						overlay0 = "#606234",
						surface2 = "#686868",
						surface1 = "#585858",
						surface0 = "#484848",
						base = "#352828",
						mantle = "#231C1E",
						crust = "#231C1E",
					},
				},
			})
			vim.api.nvim_command("colorscheme catppuccin")
		end,
	},
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "echasnovski/mini.pairs", enabled = false },
	{
		"ThePrimeagen/harpoon",
		requires = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Create harpoon mark",
			},
			{
				"<leader>m",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Harpoon quickfix toggle",
			},
			{
				"<leader>o",
				function()
					require("harpoon.ui").nav_next()
				end,
				desc = "Navigate to next harpoon mark",
			},
			{
				"<leader>i",
				function()
					require("harpoon.ui").nav_prev()
				end,
				desc = "Navigate to prev harpoon mark",
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
			{
				"-",
				":Telescope file_browser path=%:p:h select_buffer=true initial_mode=normal<CR>",
				mode = { "n", "x" },
			},
		},
		opts = {
			defaults = require("telescope.themes").get_ivy(),
			insert_mode = "normal",
		},
	},
	{ "mg979/vim-visual-multi", lazy = false },
	{
		"folke/drop.nvim",
		config = function()
			require("drop").setup({
				theme = "leaves",
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
