return {
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
			vendors = {
				ollama = {
					api_key_name = "",
					ask = "",
					endpoint = "http://127.0.0.1:11434/api",
					model = "deepseek-r1:7b",
					-- model = "qwen2.5-coder:14b",
					-- model = "llama3.1:latest",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								options = {
									num_ctx = 16384,
								},
								messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
								stream = true,
							},
						}
					end,
					parse_stream_data = function(data, handler_opts)
						-- Parse the JSON data
						local json_data = vim.fn.json_decode(data)
						-- Check for stream completion marker first
						if json_data and json_data.done then
							handler_opts.on_complete(nil) -- Properly terminate the stream
							return
						end
						-- Process normal message content
						if json_data and json_data.message and json_data.message.content then
							-- Extract the content from the message
							local content = json_data.message.content
							-- Call the handler with the content
							handler_opts.on_chunk(content)
						end
					end,
				},
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
