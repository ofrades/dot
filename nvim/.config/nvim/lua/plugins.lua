return {
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{
		"echasnovski/mini.pairs",
		enabled = true,
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader>k", "<cmd>:lua require'telescope.builtin'.grep_string()<CR>", mode = { "n", "x" } },
		},
	},
	{
		"gabrielpoca/replacer.nvim",
		keys = { { "<leader>r", ":lua require('replacer').run()<cr>', { silent = true }", desc = "Replacer" } },
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
		"gbprod/yanky.nvim",
		opts = {
			highlight = { timer = 200 },
		},
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
			{ "<c-n>", "<Plug>(YankyCycleForward)" },
			{ "<c-p>", "<Plug>(YankyCycleBackward)" },
		},
	},
	{
		"vim-test/vim-test",
	},
	{
		"cshuaimin/ssr.nvim",
		config = function()
			require("ssr").setup({
				min_width = 50,
				min_height = 5,
				max_width = 120,
				max_height = 25,
				keymaps = {
					close = "q",
					next_match = "n",
					prev_match = "N",
					replace_confirm = "<cr>",
					replace_all = "<leader><cr>",
				},
			})
		end,
	},
	{
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		keys = {
			{
				"<leader>op",
				function()
					local peek = require("peek")
					if peek.is_open() then
						peek.close()
					else
						peek.open()
					end
				end,
				desc = "Peek (Markdown Preview)",
			},
		},
		opts = { theme = "light" },
	},
	{
		"echasnovski/mini.files",
		opts = {
			windows = {
				preview = true,
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 50,
				-- Width of preview window
				width_preview = 100,
			},
			options = {
				use_as_default_explorer = true,
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
					"<leader>h",
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
