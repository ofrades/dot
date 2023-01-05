return {

	-- drop
	{
		"folke/drop.nvim",
		config = function()
			require("drop").setup({
				theme = "snow",
			})
		end,
	},

	-- term
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 20
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.3
					end
				end,
				start_in_insert = false,
				open_mapping = [[<c-\>]],
				direction = "float",
			})
		end,
	},

	-- test
	{
		"vim-test/vim-test",
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"haydenmeade/neotest-jest",
			"nvim-neotest/neotest-vim-test",
			"akinsho/toggleterm.nvim",
		},
		config = function()
			local tt = require("toggleterm")
			local ttt = require("toggleterm.terminal")

			vim.g["test#custom_strategies"] = {
				tterm = function(cmd)
					tt.exec(cmd)
				end,

				tterm_close = function(cmd)
					local term_id = 0
					tt.exec(cmd, term_id)
					ttt.get_or_create_term(term_id):close()
				end,
			}

			vim.g["test#strategy"] = {
				nearest = "tterm",
				file = "tterm",
				suite = "tterm",
			}
			require("neotest").setup({
				icons = {
					passed = "",
					failed = "",
					skipped = "ﭡ",
					unknown = "",
					running = "",
					running_animated = { "", "", "", "", "", "", "", "", "" },
				},
				output = {
					enabled = true,
					open_on_run = true,
				},
				run = {
					enabled = true,
				},
				status = {
					enabled = true,
					virtual_text = true,
				},
				strategies = {
					integrated = {
						height = 40,
						width = 120,
					},
				},
				summary = {
					enabled = true,
					expand_errors = true,
					follow = true,
					mappings = {
						attach = "a",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						output = "o",
						run = "r",
						short = "O",
						stop = "x",
					},
				},
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test --",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
				},
			})
		end,
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

	-- mini
	{
		"echasnovski/mini.animate",
		config = function()
			require("mini.animate").setup()
		end,
	},

	-- indentscope
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
	},
	{
		"echasnovski/mini.indentscope",
		enabled = true,
	},

	-- diffview
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
				keymaps = {
					file_panel = {
						["q"] = "<Cmd>tabc<CR>",
					},
				},
			})
		end,
	},

	-- yanky
	{
		"gbprod/yanky.nvim",
		config = function()
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
		config = function()
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
		config = function()
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
		config = function()
			require("scrollbar").setup()
		end,
	},

	-- colorscheme
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
	},

	-- null-ls
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
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
					null_ls.builtins.formatting.markdownlin,
					null_ls.builtins.code_actions.refactoring,
				},
			})
		end,
	},
}
