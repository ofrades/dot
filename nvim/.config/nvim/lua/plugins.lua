return {
	-- drop
	{
		"folke/drop.nvim",
		config = function()
			require("drop").setup({
				theme = "spring",
			})
		end,
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
			"haydenmeade/neotest-jest",
			"marilari88/neotest-vitest",
			{
				"andythigpen/nvim-coverage",
				opts = {
					commands = true,
					summary = {
						min_coverage = 80.0,
					},
				},
			},
		},
		lazy = false,
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-vitest"),
					require("neotest-jest")({
						jestCommand = "npm test -- --coverage",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
				},
				status = {
					virtual_text = true,
				},
				output = {
					enabled = false,
				},
				quickfix = {
					enabled = false,
				},
				output_panel = {
					enabled = true,
				},
				state = {
					enabled = true,
				},
				icons = {
					collapsed = "",
					passed = "",
					running = "󰥔",
					failed = "",
				},
			})
		end,
		keys = {
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
					require("neotest").output_panel.open()
				end,
				desc = "Test nearest",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
					require("neotest").output_panel.open()
				end,
				desc = "Test file",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.run({ suite = true })
					require("neotest").output_panel.open()
				end,
				desc = "Test suite",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Open summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Open outpup",
			},
		},
	},
	{
		"epwalsh/obsidian.nvim",
		event = { "BufReadPre " .. vim.fn.expand("~") .. "/pCloudDrive/obsidian/**.md" },
		opts = {
			dir = "~/pCloudDrive/obsidian", -- no need to call 'vim.fn.expand' here

			-- Optional, if you keep notes in a specific subdirectory of your vault.
			notes_subdir = "notes",

			-- Optional, if you keep daily notes in a separate directory.
			daily_notes = {
				folder = "notes/dailies",
			},
		},
	},

	-- disable
	{ "ggandor/flit.nvim", enabled = false },
	{ "ggandor/leap.nvim", enabled = false },
}
