return {

	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			{
				"mfussenegger/nvim-dap",
			},
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
				tag = "v1.74.1",
			},
		},
		config = function()
			local vscodeJsDebugPath = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"

			require("dap-vscode-js").setup({
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
				debugger_path = vscodeJsDebugPath,
			})
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				require("dap").configurations[language] = {
					{
						type = "chrome",
						request = "launch",
						name = "Launch Chrome against localhost",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach Program (pwa-node, select pid)",
						cwd = "${workspaceFolder}",
						processId = require("dap.utils").pick_process,
						skipFiles = { "<node_internals>/**" },
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (pwa-node)",
						cwd = vim.fn.getcwd(),
						args = { "${file}" },
						sourceMaps = true,
						protocol = "inspector",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (pwa-node with ts-node)",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "--loader", "ts-node/esm" },
						runtimeExecutable = "node",
						args = { "${file}" },
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Current File (pwa-node with deno)",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
						runtimeExecutable = "deno",
						attachSimplePort = 9229,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Test Current File (pwa-node with jest)",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
						runtimeExecutable = "node",
						args = { "${file}", "--coverage", "false" },
						rootPath = "${workspaceFolder}",
						sourceMaps = true,
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Test Current File (pwa-node with vitest)",
						cwd = vim.fn.getcwd(),
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
						autoAttachChildProcesses = true,
						smartStep = true,
						console = "integratedTerminal",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Test Current File (pwa-node with deno)",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
						runtimeExecutable = "deno",
						attachSimplePort = 9229,
					},
					{
						type = "pwa-chrome",
						request = "attach",
						name = "Attach Program (pwa-chrome, select port)",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						port = function()
							return vim.fn.input("Select port: ", 9222)
						end,
						webRoot = "${workspaceFolder}",
					},
				}
			end
			require("dap.ext.vscode").load_launchjs(nil, {
				["pwa-chrome"] = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			})
		end,
	},
	-- glance
	-- {
	-- 	"dnlhc/glance.nvim",
	-- 	keys = {
	-- 		{ "<leader>gr", "<CMD>Glance references<CR>", desc = "Glance references" },
	-- 	},
	-- },

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

	-- search and replace
	{
		"AckslD/muren.nvim",
		opts = {
			keys = {
				close = "q",
				toggle_side = "<Tab>",
				toggle_options_focus = "<S-Tab>",
				toggle_option_under_cursor = "<CR>",
				scroll_preview_up = "<C-u>",
				scroll_preview_down = "<C-d>",
				do_replace = "<CR>",
				-- NOTE these are not guaranteed to work, what they do is just apply `:normal! u` vs :normal! <C-r>`
				-- on the last affected buffers so if you do some edit in these buffers in the meantime it won't do the correct thing
				do_undo = "<localleader>u",
				do_redo = "<localleader>r",
			},
		},
		keys = {
			{ "<leader>sp", "<CMD>MurenToggle<CR>", desc = "Muren" },
		},
	},

	-- theme
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},

	-- drop
	{
		"folke/drop.nvim",
		config = function()
			require("drop").setup({
				theme = "summer",
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
			"marilari88/neotest-vitest",
		},
		lazy = false,
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-vitest"),
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

	-- disable
	{ "ggandor/flit.nvim", enabled = false },
	{ "ggandor/leap.nvim", enabled = false },
}
