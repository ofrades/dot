return {
	-- tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{ "<leader>e", false },
			{ "<leader>o", false },
			{
				"-",
				function()
					if vim.bo.filetype ~= "neo-tree" then
						vim.cmd.Neotree({ "position=current", "top", "reveal" })
					end
				end,
				desc = "Tree",
			},
		},
		opts = {
			filesystem = {
				hijack_netrw_behavior = "open_current",
				-- window = {
				-- 	mappings = {
				-- 		["-"] = function(state)
				-- 			require("neo-tree.ui.renderer").focus_node(state, state.tree:get_node():get_parent_id())
				-- 		end,
				-- 	},
				-- },
			},
		},
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

	-- -- theme
	-- { "ellisonleao/gruvbox.nvim", priority = 1000 },
	--
	-- {
	-- 	"LazyVim/LazyVim",
	-- 	opts = {
	-- 		colorscheme = "gruvbox",
	-- 	},
	-- },

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
