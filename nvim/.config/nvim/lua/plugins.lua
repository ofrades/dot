return {

	-- drop
	{
		"folke/drop.nvim",
		opts = function()
			require("drop").setup({
				theme = "snow",
			})
		end,
	},

	-- colorizer
	{
		"norcalli/nvim-colorizer.lua",
		opts = function()
			require("colorizer").setup()
		end,
	},

	-- oil
	{
		"stevearc/oil.nvim",
		lazy = false,
		opts = function()
			require("oil").setup()
		end,
	},

	-- vim-test
	{
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux",
		},
		lazy = false,
		config = function()
			vim.g.VimuxOrientation = "v"
			vim.g["test#strategy"] = {
				nearest = "vimux",
				file = "vimux",
				suite = "vimux",
			}
			vim.g["test#neovim#term_position"] = "vert"
		end,
		keys = {
			{
				"<leader>tF",
				"<cmd>:TestFile<cr>",
				desc = "Test file with vim-test",
			},
			{
				"<leader>tN",
				"<cmd>:TestNearest<cr>",
				desc = "Test nearest with vim-test",
			},
			{
				"<leader>tS",
				"<cmd>:TestSuite<cr>",
				desc = "Test suite with vim-test",
			},
		},
	},

	-- Task runner and job management
	{
		"stevearc/overseer.nvim",
		lazy = true,
		config = {
			component_aliases = {
				default_neotest = {
					"on_output_summarize",
					"on_exit_set_status",
					"on_complete_dispose",
					{ "on_complete_notify", system = "unfocused", on_change = true },
				},
			},
		},
	},

	-- git
	{
		"sindrets/diffview.nvim",
		opts = function()
			require("diffview").setup({
				keymaps = {
					file_panel = {
						["q"] = "<Cmd>tabc<CR>",
					},
				},
			})
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		config = function()
			require("gitlinker").setup()
		end,
	},
	{
		"TimUntersberger/neogit",
		dependencies = {
			"sindrets/diffview.nvim",
		},
		opts = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
				},
			})
		end,
	},

	-- neotest
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"haydenmeade/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-vim-test",
			"nvim-neotest/neotest-python",
			"Issafalcon/neotest-dotnet",
			"rouge8/neotest-rust",
			"stevearc/overseer.nvim",
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
					require("neotest-go"),
					require("neotest-vitest"),
					-- require("neotest-vim-test"),
					require("neotest-python"),
					require("neotest-dotnet"),
					require("neotest-rust"),
				},
				consumers = {
					overseer = require("neotest.consumers.overseer"),
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
				end,
				desc = "Test nearest with neotest",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Test file with neotest",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Open summary with neotest",
			},
			{
				"<leader>tw",
				"<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
				desc = "Test jest in watch mode",
			},
			{
				"<leader>to",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Open outpup with neotest",
			},
			{
				"<leader>oo",
				"<cmd>OverseerToggle<CR>",
				desc = "Open overseer",
			},
		},
	},

	{
		"ggandor/leap.nvim",
		enabled = false,
	},

	-- ssr
	{
		"cshuaimin/ssr.nvim",
		keys = {
			{
				"<leader>st",
				function()
					require("ssr").open()
				end,
				desc = "Search and replace in buffer",
			},
		},
		opts = function()
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

	-- indentscope
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
	},
	{
		"echasnovski/mini.indentscope",
	},

	-- yanky
	{
		"gbprod/yanky.nvim",
		opts = function()
			require("yanky").setup({
				ring = {
					history_length = 100,
					storage = "shada",
					sync_with_numbered_registers = true,
					cancel_event = "update",
				},
				highlight = {
					timer = 100,
				},
				system_clipboard = {
					sync_with_ring = true,
				},
			})
		end,
	},

	-- harpoon
	{
		"ThePrimeagen/harpoon",
	},

	-- refactoring
	{
		"ThePrimeagen/refactoring.nvim",
		opts = function()
			require("refactoring").setup({})
		end,
	},

	-- windows
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		opts = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup({
				animation = {
					duration = 150,
				},
			})
			vim.keymap.set("n", "<leader>Z", "<Cmd>WindowsMaximaze<CR>")
		end,
	},

	-- scrollbar
	{
		"petertriho/nvim-scrollbar",
		opts = function()
			require("scrollbar").setup()
		end,
	},

	-- null-ls
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.completion.spell,
					null_ls.builtins.diagnostics.actionlint,
					null_ls.builtins.diagnostics.write_good,
					null_ls.builtins.diagnostics.yamllint,
					null_ls.builtins.diagnostics.flake8,
					-- null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.jq,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.fixjson,
					null_ls.builtins.formatting.yamlfmt,
					null_ls.builtins.formatting.markdownlint,
					null_ls.builtins.code_actions.refactoring,
				},
			})
		end,
	},
}
