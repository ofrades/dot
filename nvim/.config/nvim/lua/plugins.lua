return {
	{ "akinsho/bufferline.nvim", enabled = false },
	{
		"TimUntersberger/neogit",
		dependencies = {
			"sindrets/diffview.nvim",
		},
		cmd = "Neogit",
		keys = { { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" } },
		opts = {
			integrations = {
				diffview = true,
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
		},
		keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" } },
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
		"echasnovski/mini.pairs",
		enabled = false,
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

	-- harpoon
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "n", "<leader>ma", ":lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file" } },
			{
				"n",
				"<leader>mm",
				":lua require('harpoon.ui').toggle_quick_menu()<cr>",
				{ desc = "View project marks" },
			},
			{ "n", "<leader>mi", ":lua require('harpoon.ui').nav_next()<cr>", { desc = "Next mark" } },
			{ "n", "<leader>mo", ":lua require('harpoon.ui').nav_prev()<cr>", { desc = "Previous mark" } },
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
	-- color
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

	-- test
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
					-- Custom hook to open the output panel
					-- after test results that fail,
					-- and auto-focus the panel and jump to its bottom
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
