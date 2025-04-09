return {
	{
		"nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
		},
	},
	{ "echasnovski/mini.pairs", enabled = false },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "mg979/vim-visual-multi" },
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		opts = {
			provider = "ollama",
			ollama = {
				endpoint = "http://127.0.0.1:11434",
				model = "codellama:7b",
			},
		},
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			--Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
			strategies = {
				--NOTE: Change the adapter as required
				chat = { adapter = "ollama" },
				inline = { adapter = "ollama" },
			},
			opts = {
				log_level = "DEBUG",
			},
		},
	},
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
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"leader>-",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<c-up>",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		opts = {
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
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
