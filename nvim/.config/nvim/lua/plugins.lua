return {
	-- custom lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
		},
		opts = {
			setup = {
				tsserver = function(_, opts)
					require("lazyvim.util").on_attach(function(client)
						if client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
						end
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						end
					end)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},

	-- drop
	{
		"folke/drop.nvim",
		opts = function()
			require("drop").setup({
				theme = "snow",
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
					open_on_run = false,
				},
				quickfix = {
					enabled = false,
				},
				output_panel = {
					enabled = true,
				},
				icons = {
					expanded = "",
					child_prefix = "",
					child_indent = "",
					final_child_prefix = "",
					non_collapsible = "",
					collapsed = "",
					passed = "",
					running = "",
					failed = "",
					unknown = "",
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
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
}
