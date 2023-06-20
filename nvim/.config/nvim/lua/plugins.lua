return {
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
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPTActAs", "ChatGPT" },
		opts = {},
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
			{ "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
			{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
		},
	},
	{ "ggandor/leap.nvim", enabled = false },
	{ "ggandor/flit.nvim", enabled = false },
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
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{ "-", "<Cmd>Neotree position=current top reveal<cr>" },
		},
		opts = {
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
						require("neo-tree").close_all()
					end,
				},
			},
		},
	},

	-- harpoon
	{
		"ThePrimeagen/harpoon",
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
						end
					end
				end,
			},
		},
	},
}
