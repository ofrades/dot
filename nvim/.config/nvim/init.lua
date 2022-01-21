local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			"jose-elias-alvarez/null-ls.nvim",
			"ray-x/lsp_signature.nvim",
		},
		config = function()
			require("config.lsp")
			require("lsp_signature").setup()
		end,
	})

	use({
		"akinsho/nvim-toggleterm.lua",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				shading_factor = 0.3,
				size = vim.o.columns * 0.3,
				start_in_insert = true,
				direction = "vertical",
			})

			vim.cmd([[tnoremap <esc> <C-\><C-N>]])
		end,
	})

	use({
		"vim-test/vim-test",
		requires = {
			"rcarriga/vim-ultest",
		},
		run = ":UpdateRemotePlugins",
		config = function()
			vim.g["test#strategy"] = "neovim"
			vim.g["test#neovim#term_position"] = "vert"
			vim.g["test#preserve_screen"] = 1
			vim.g.neoterm_shell = "fish"
			vim.g.neoterm_default_mod = "vertical"
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						scope_incremental = "<CR>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
					},
				},
				context_commentstring = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
		end,
	})

	use({ "tpope/vim-fugitive" })

	use({
		"tpope/vim-surround",
	})
	use({
		"tpope/vim-repeat",
	})

	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("config.cmp")
		end,
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"lukas-reineke/cmp-rg",
			"petertriho/cmp-git",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
			{ "tzachar/cmp-tabnine", run = "./install.sh" },
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("config.snippets")
				end,
			},
			"rafamadriz/friendly-snippets",
			{
				"windwp/nvim-autopairs",
				config = function()
					require("nvim-autopairs").setup()
				end,
			},
		},
	})

	use({ "kevinhwang91/nvim-bqf", ft = "qf" })

	use({
		"elihunter173/dirbuf.nvim",
		config = function()
			require("dirbuf").setup({
				show_hidden = true,
			})
		end,
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			local tree_cb = require("nvim-tree.config").nvim_tree_callback
			require("nvim-tree").setup({
				open_on_setup = false,
				ignore_ft_on_setup = {},
				auto_close = false,
				open_on_tab = true,
				hijack_cursor = false,
				update_cwd = true,
				update_focused_file = {
					enable = true,
					update_cwd = true,
					ignore_list = {},
				},
				update_to_buf_dir = {
					enable = true,
					auto_open = true,
				},
				system_open = {
					cmd = nil,
					args = {},
				},
				git = {
					enable = true,
					ignore = true,
					timeout = 500,
				},
				view = {
					width = 40,
					side = "left",
					auto_resize = true,
					signcolumn = "yes",
					number = true,
					mappings = {
						custom_only = false,
						list = {
							{ key = { "<CR>", "o", "l" }, cb = tree_cb("edit") },
							{ key = "<C-]>", cb = tree_cb("cd") },
							{ key = "<C-[>", cb = tree_cb("dir_up") },
							{ key = "<C-v>", cb = tree_cb("vsplit") },
							{ key = "<C-x>", cb = tree_cb("split") },
							{ key = "<C-t>", cb = tree_cb("tabnew") },
							{ key = "<BS>", cb = tree_cb("close_node") },
							{ key = "<S-CR>", cb = tree_cb("close_node") },
							{ key = "h", cb = tree_cb("close_node") },
							{ key = "<Tab>", cb = tree_cb("preview") },
							{ key = "I", cb = tree_cb("toggle_ignored") },
							{ key = "H", cb = tree_cb("toggle_dotfiles") },
							{ key = "R", cb = tree_cb("refresh") },
							{ key = "a", cb = tree_cb("create") },
							{ key = "d", cb = tree_cb("remove") },
							{ key = "r", cb = tree_cb("rename") },
							{ key = "<C-r>", cb = tree_cb("full_rename") },
							{ key = "x", cb = tree_cb("cut") },
							{ key = "c", cb = tree_cb("copy") },
							{ key = "p", cb = tree_cb("paste") },
							{ key = "[c", cb = tree_cb("prev_git_item") },
							{ key = "]c", cb = tree_cb("next_git_item") },
							{ key = "q", cb = tree_cb("close") },
						},
					},
				},
			})
		end,
	})

	use({ "tpope/vim-commentary" })

	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	use({
		"akinsho/nvim-bufferline.lua",
		event = "BufReadPre",
		wants = "nvim-web-devicons",
		config = function()
			local signs = require("config.lsp").signs

			signs = {
				error = signs.Error,
				warning = signs.Warn,
				info = signs.Info,
				hint = signs.Hint,
			}

			local severities = {
				"error",
				"warning",
				-- "info",
				-- "hint",
			}

			require("bufferline").setup({
				options = {
					show_close_icon = true,
					diagnostics = "nvim_lsp",
					always_show_bufferline = false,
					separator_style = "thick",
					diagnostics_indicator = function(_, _, diag)
						local s = {}
						for _, severity in ipairs(severities) do
							if diag[severity] then
								table.insert(s, signs[severity] .. diag[severity])
							end
						end
						return table.concat(s, " ")
					end,
					offsets = {
						{
							filetype = "NvimTree",
							text = "NvimTree",
							highlight = "Directory",
							text_align = "left",
						},
					},
				},
			})
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "rlch/github-notifications.nvim" },
		config = function()
			local function holidays()
				return "🎅🎄🌟🎁👑"
			end

			local function lsp_progress(_, is_active)
				if not is_active then
					return
				end
				local messages = vim.lsp.util.get_progress_messages()
				if #messages == 0 then
					return ""
				end
				-- dump(messages)
				local status = {}
				for _, msg in pairs(messages) do
					local title = ""
					if msg.title then
						title = msg.title
					end
					-- if msg.message then
					--   title = title .. " " .. msg.message
					-- end
					table.insert(status, (msg.percentage or 0) .. "%% " .. title)
				end
				local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				local ms = vim.loop.hrtime() / 1000000
				local frame = math.floor(ms / 120) % #spinners
				return table.concat(status, "   ") .. " " .. spinners[frame + 1]
			end

			vim.cmd("au User LspProgressUpdate let &ro = &ro")

			local config = {
				options = {
					theme = "tokyonight",
					section_separators = { left = " ", right = " " },
					component_separators = { left = " ", right = " " },
					icons_enabled = true,
					mappings = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{ "diagnostics", sources = { "nvim_diagnostic" } },
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "" } },
						{
							function()
								local gps = require("nvim-gps")
								return gps.get_location()
							end,
							cond = function()
								local gps = require("nvim-gps")
								return pcall(require, "nvim-treesitter.parsers") and gps.is_available()
							end,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_x = { holidays },
					lualine_y = { lsp_progress },
					lualine_z = { "os.date('%a %H:%M')" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "nvim-tree" },
			}

			require("lualine").setup(config)
		end,
	})
	use({
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
		wants = "nvim-treesitter",
		module = "nvim-gps",
		config = function()
			require("nvim-gps").setup({ separator = " " })
		end,
	})

	use({
		"RRethy/vim-illuminate",
		event = "CursorHold",
		module = "illuminate",
		config = function()
			vim.g.Illuminate_delay = 1000
		end,
	})

	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	})

	use({
		"windwp/nvim-spectre",
		require("spectre").setup({
			is_insert_mode = true,
			live_update = true,
			mapping = {
				["toggle_line"] = {
					map = "dd",
					cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
					desc = "toggle current item",
				},
				["enter_file"] = {
					map = "<cr>",
					cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
					desc = "goto current file",
				},
				["send_to_qf"] = {
					map = "qq",
					cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
					desc = "send all item to quickfix",
				},
				["replace_cmd"] = {
					map = "<leader>c",
					cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
					desc = "input replace vim command",
				},
				["show_option_menu"] = {
					map = "<leader>o",
					cmd = "<cmd>lua require('spectre').show_options()<CR>",
					desc = "show option",
				},
				["run_replace"] = {
					map = "<leader>r",
					cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
					desc = "replace all",
				},
				["change_view_mode"] = {
					map = "<leader>v",
					cmd = "<cmd>lua require('spectre').change_view()<CR>",
					desc = "change result view mode",
				},
				["toggle_live_update"] = {
					map = "<leader>u",
					cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
					desc = "update change when vim write file.",
				},
				["toggle_ignore_case"] = {
					map = "<leader>i",
					cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
					desc = "toggle ignore case",
				},
				["toggle_ignore_hidden"] = {
					map = "<leader>h",
					cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
					desc = "toggle search hidden",
				},
			},
		}),
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"cljoly/telescope-repo.nvim",
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").load_extension("repo")
			require("telescope").load_extension("file_browser")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<ESC>"] = actions.close,
						},
					},
				},
			})
		end,
	})

	use({
		"pwntester/octo.nvim",
		config = function()
			require("octo").setup()
		end,
	})

	use({ "lukas-reineke/indent-blankline.nvim" })

	use({ "sindrets/diffview.nvim" })

	use({
		"karb94/neoscroll.nvim",
		keys = { "<C-u>", "<C-d>", "<C-e>", "<C-y>", "gg", "G" },
		config = function()
			require("neoscroll").setup({
				hide_cursor = false,
				easing_function = "nil",
			})
			require("neoscroll.config").set_mappings({
				["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200" } },
				["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200" } },
				["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "300" } },
				["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "300" } },
				["<C-y>"] = { "scroll", { "-0.10", "false", "50" } },
				["<C-e>"] = { "scroll", { "0.10", "false", "50" } },
				["zt"] = { "zt", { "300" } },
				["zz"] = { "zz", { "300" } },
				["zb"] = { "zb", { "300" } },
			})
		end,
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require("refactoring").setup({})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = {
						hl = "GitSignsAdd",
						text = "▍",
					},
					change = {
						hl = "GitSignsChange",
						text = "▍",
					},
					delete = {
						hl = "GitSignsDelete",
						text = "▸",
					},
					topdelete = {
						hl = "GitSignsDelete",
						text = "▾",
					},
					changedelete = {
						hl = "GitSignsChange",
						text = "▍",
					},
				},
				keymaps = {
					noremap = true,
					["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" },
					["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" },
					["n <leader>hs"] = "<cmd>Gitsigns stage_hunk<CR>",
					["v <leader>hs"] = ":Gitsigns stage_hunk<CR>",
					["n <leader>hu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",
					["n <leader>hr"] = "<cmd>Gitsigns reset_hunk<CR>",
					["v <leader>hr"] = ":Gitsigns reset_hunk<CR>",
					["n <leader>hR"] = "<cmd>Gitsigns reset_buffer<CR>",
					["n <leader>hp"] = "<cmd>Gitsigns preview_hunk<CR>",
					["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
					["n <leader>hS"] = "<cmd>Gitsigns stage_buffer<CR>",
					["n <leader>hU"] = "<cmd>Gitsigns reset_buffer_index<CR>",
					["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
					["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
				},
			})
		end,
	})

	use({ "kdheepak/lazygit.nvim" })

	use({ "mg979/vim-visual-multi" })

	use({
		"norcalli/nvim-colorizer.lua",
		requires = {
			"folke/tokyonight.nvim",
			"projekt0n/github-nvim-theme",
		},
		config = function()
			require("colorizer").setup(nil, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes: foreground, background
				mode = "background", -- Set the display mode.
			})

			vim.cmd(
				[[autocmd ColorScheme * lua package.loaded['colorizer'] = nil; require('colorizer').setup(); require('colorizer').attach_to_buffer(0)]]
			)

			vim.o.background = "dark"

			vim.g.tokyonight_dev = true
			vim.g.tokyonight_style = "storm"
			vim.g.tokyonight_sidebars = {
				"qf",
				"vista_kind",
				"terminal",
				"packer",
				"spectre_panel",
				"NeogitStatus",
				"help",
			}
			vim.g.tokyonight_cterm_colors = false
			vim.g.tokyonight_terminal_colors = true
			vim.g.tokyonight_italic_comments = true
			vim.g.tokyonight_italic_keywords = true
			vim.g.tokyonight_italic_functions = false
			vim.g.tokyonight_italic_variables = false
			vim.g.tokyonight_transparent = false
			vim.g.tokyonight_hide_inactive_statusline = true
			vim.g.tokyonight_dark_sidebar = true
			vim.g.tokyonight_dark_float = true
			vim.g.tokyonight_colors = {}

			require("tokyonight").colorscheme()
		end,
	})

	use({
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran", jump_on_sole_occurence = true })
		end,
	})

	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({ keywords = { TODO = { alt = { "WIP" } } } })
		end,
	})

	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})
		end,
	})

	use({
		"petertriho/nvim-scrollbar",
		requires = {
			"kevinhwang91/nvim-hlslens",
		},
		config = function()
			require("scrollbar").setup()
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("config.keys")
		end,
	})
	if packer_bootstrap then
		require("packer").sync()
	end
end)

local cmd = vim.cmd
local indent = 2

--[[ vim.bo.expandtab = true -- Use spaces instead of tabs
vim.bo.shiftwidth = indent -- Size of an indent
vim.bo.smartindent = true -- Insert indents automatically
vim.bo.undofile = true ]]
vim.g.mapleader = " "

vim.opt.backup = false -- creates a backupt file
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hlsearch = true
vim.opt.ignorecase = true -- Ignore case
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
vim.opt.foldlevel = 10
vim.opt.foldmethod = "expr" -- TreeSitter folding
vim.opt.guifont = "FiraCode Nerd Font:h12"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.inccommand = "split" -- preview incremental substitute
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = indent -- Size of an indent
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- save swap file and trigger CursorHold
vim.opt.swapfile = false
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = false -- Disable line wrap
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.o.shortmess = "IToOlxfitn"
vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.opt.shell = "fish"

-- don't load the plugins below
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- go to last loc when opening a buffer
cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- Highlight on yank
cmd("au TextYankPost * lua vim.highlight.on_yank {}")
