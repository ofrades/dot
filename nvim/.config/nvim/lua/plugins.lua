return {
	{ "akinsho/bufferline.nvim", enabled = false },
	{ "folke/flash.nvim", enabled = false },
	{ "echasnovski/mini.pairs", enabled = false },
	{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
	{
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				require("rose-pine").setup({
					variant = "moon",
					dark_variant = "moon",
				})
			end,
		},
		{
			"LazyVim/LazyVim",
			opts = {
				colorscheme = "rose-pine",
			},
		},
	},
	{ "mg979/vim-visual-multi" },
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
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				["mdx"] = { { "prettier" } },
			},
		},
	},
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	optional = true,
	-- 	opts = {
	-- 		linters_by_ft = {
	-- 			["mdx"] = { "mdx-analyzer", "eslint" },
	-- 			["markdown.mdx"] = { "mdx-analyzer", "eslint" },
	-- 		},
	-- 	},
	-- },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			global_settings = {
				-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
				save_on_toggle = true,

				-- saves the harpoon file upon every change. disabling is unrecommended.
				save_on_change = true,

				-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
				enter_on_sendcmd = false,

				-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
				tmux_autoclose_windows = false,

				-- filetypes that you want to prevent from adding to the harpoon list menu.
				excluded_filetypes = { "harpoon" },

				-- set marks specific to each git branch inside git repository
				mark_branch = true,

				-- enable tabline with harpoon marks
				tabline = false,
				tabline_prefix = "   ",
				tabline_suffix = "   ",
			},
		},
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():append()
				end,
				desc = "Create harpoon mark",
			},
			{
				"<leader>m",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon quickfix toggle",
			},
			{
				"<leader>o",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Navigate to next harpoon mark",
			},
			{
				"<leader>i",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Navigate to prev harpoon mark",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{ "<leader>k", "<cmd>:lua require'telescope.builtin'.grep_string()<CR>", mode = { "n", "x" } },
			{ "<leader>gc", "<cmd>:lua require'telescope.builtin'.git_bcommits()<CR>", mode = { "n", "x" } },
			-- {
			-- 	"-",
			-- 	":Telescope file_browser path=%:p:h select_buffer=true initial_mode=normal<CR>",
			-- 	mode = { "n", "x" },
			-- },
		},
		config = function(plugin, opts)
			local fb_actions = require("telescope._extensions.file_browser.actions")

			require("telescope").setup({
				defaults = require("telescope.themes").get_ivy({
					wrap_results = true,
					winblend = 10,
					width = 1,
					show_line = true,
					previewer = true,
					-- sorting_strategy = "descending",
					-- layout_config = {
					-- 	prompt_position = "bottom",
					-- },
				}),
				insert_mode = "normal",
				extensions = {
					file_browser = {
						mappings = {
							["n"] = {
								["c"] = fb_actions.create,
								["r"] = fb_actions.rename,
								["m"] = fb_actions.move,
								["y"] = fb_actions.copy,
								["d"] = fb_actions.remove,
								["o"] = fb_actions.open,
								["l"] = require("telescope.actions").select_default,
								["h"] = fb_actions.goto_parent_dir,
								["-"] = fb_actions.goto_parent_dir,
								["e"] = fb_actions.goto_home_dir,
								["w"] = fb_actions.goto_cwd,
								["t"] = fb_actions.change_cwd,
								["f"] = fb_actions.toggle_browser,
								["."] = fb_actions.toggle_hidden,
								["s"] = fb_actions.toggle_all,
							},
						},
					},
				},
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
	{
		"nvim-neotest/neotest",
		dependencies = {
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-vim-test",
		},
		opts = {
			adapters = {
				-- ["neotest-vitest"] = {},
				-- ["neotest-vim-test"] = {
				-- 	ignore_file_types = { "typescriptreact", "typescript" },
				-- },
				["neotest-vim-test"] = {},
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
