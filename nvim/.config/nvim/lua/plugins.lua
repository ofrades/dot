return {
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "echasnovski/mini.pairs", enabled = false },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function(_, opts)
			require("harpoon"):setup(opts)
		end,
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():append()
				end,
				desc = "Create harpoon mark",
			},
			{
				"<leader>m",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon quickfix toggle",
			},
			{
				"<leader>o",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Navigate to next harpoon mark",
			},
			{
				"<leader>i",
				function()
					require("harpoon"):list():prev()
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
		config = function(plugin, opts)
			local fb_actions = require("telescope._extensions.file_browser.actions")

			require("telescope").setup({
				defaults = require("telescope.themes").get_ivy({
					wrap_results = true,
					winblend = 10,
					width = 1,
					show_line = true,
					previewer = true,
					sorting_strategy = "descending",
					layout_config = {
						prompt_position = "bottom",
						preview_width = 0.4,
					},
				}),
				insert_mode = "normal",
				extensions = {
					file_browser = {
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						mappings = {
							["n"] = {
								["c"] = fb_actions.create,
								["r"] = fb_actions.rename,
								["m"] = fb_actions.move,
								["y"] = fb_actions.copy,
								["d"] = fb_actions.remove,
								["o"] = fb_actions.open,
								["l"] = require("telescope.actions").select_default,
								["h"] = fb_actions.goto_parent_dir,
								["-"] = fb_actions.goto_parent_dir,
								["e"] = fb_actions.goto_home_dir,
								["w"] = fb_actions.goto_cwd,
								["t"] = fb_actions.change_cwd,
								["f"] = fb_actions.toggle_browser,
								["."] = fb_actions.toggle_hidden,
								["s"] = fb_actions.toggle_all,
							},
						},
					},
				},
			})
		end,
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
