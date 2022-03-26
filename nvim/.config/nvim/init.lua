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
			"jose-elias-alvarez/null-ls.nvim",
			"ray-x/lsp_signature.nvim",
		},
		config = function()
			require("config.lsp")
			require("lsp_signature").setup()
		end,
	})

	use({ "kassio/neoterm" })
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
	})

	use({
		"vim-test/vim-test",
		run = ":UpdateRemotePlugins",
		config = function()
			vim.g["test#neovim#start_normal"] = 1
			vim.g["neoterm_autoscroll"] = 1
			vim.g["test#strategy"] = {
				nearest = "neoterm",
				file = "neoterm",
				suite = "neoterm",
			}
			vim.g["test#javascript#jest#options"] = {
				nearest = "--watch",
				file = "--watch",
				suite = "--bail",
			}
			vim.g.neoterm_default_mod = "botright"
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

	use({
		"tpope/vim-fugitive",
		requires = { "tpope/vim-rhubarb", "junegunn/gv.vim" },
	})
	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })
	use({
		"tpope/vim-projectionist",
		config = function()
			vim.g.projectionist_heuristics = {
				["package.json"] = {
					["*.ts"] = {
						["alternate"] = "{}.spec.ts",
						["alternate"] = "{}.test.ts",
					},
					["*.test.ts"] = {
						["alternate"] = "{}.ts",
					},
					["*.spec.ts"] = {
						["alternate"] = "{}.ts",
					},
					["*.js"] = {
						["alternate"] = "{}.spec.js",
						["alternate"] = "{}.test.js",
					},
					["*.test.js"] = {
						["alternate"] = "{}.js",
					},
					["*.spec.js"] = {
						["alternate"] = "{}.js",
					},
					["*.tsx"] = {
						["alternate"] = "{}.spec.tsx",
						["alternate"] = "{}.test.tsx",
					},
					["*.test.tsx"] = {
						["alternate"] = "{}.tsx",
					},
					["*.spec.tsx"] = {
						["alternate"] = "{}.tsx",
					},
					["*.jsx"] = {
						["alternate"] = "{}.spec.jsx",
						["alternate"] = "{}.test.jsx",
					},
					["*.test.jsx"] = {
						["alternate"] = "{}.jsx",
					},
					["*.spec.jsx"] = {
						["alternate"] = "{}.jsx",
					},
				},
			}
		end,
	})
	use({ "tpope/vim-dispatch" })
	use({ "tpope/vim-commentary" })

	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("config.cmp")
		end,
		requires = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"f3fora/cmp-spell",
			"petertriho/cmp-git",
			"lukas-reineke/cmp-rg",
			{ "tzachar/cmp-tabnine", run = "./install.sh" },
			{
				"L3MON4D3/LuaSnip",
				wants = "friendly-snippets",
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

	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			local tree_cb = require("nvim-tree.config").nvim_tree_callback
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,
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
							{ key = "<C-v>", cb = tree_cb("vsplit") },
							{ key = "<C-s>", cb = tree_cb("split") },
							{ key = "<C-t>", cb = tree_cb("tabnew") },
							{ key = "<BS>", cb = tree_cb("close_node") },
							{ key = "<S-CR>", cb = tree_cb("close_node") },
							{ key = "h", cb = tree_cb("close_node") },
							{ key = "R", cb = tree_cb("refresh") },
							{ key = "a", cb = tree_cb("create") },
							{ key = "d", cb = tree_cb("remove") },
							{ key = "r", cb = tree_cb("rename") },
							{ key = "x", cb = tree_cb("cut") },
							{ key = "c", cb = tree_cb("copy") },
							{ key = "p", cb = tree_cb("paste") },
							{ key = "q", cb = tree_cb("close") },
						},
					},
				},
			})
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
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
					theme = "github_dimmed",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "diagnostics", sources = { "nvim_diagnostic" } },
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "" } },
					},
					lualine_c = {},
					lualine_x = {},
					lualine_y = { lsp_progress },
					lualine_z = { "branch" },
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
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
		"RRethy/vim-illuminate",
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
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("fzf")
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

	use({ "sindrets/diffview.nvim" })

	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
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
				keymaps = {
					noremap = true,
					["n <leader>hp"] = "<cmd>Gitsigns preview_hunk<CR>",
					["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
				},
			})
		end,
	})

	use({ "kdheepak/lazygit.nvim" })

	use({ "mg979/vim-visual-multi" })

	use({
		"norcalli/nvim-colorizer.lua",
		requires = {
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

			require("github-theme").setup({
				theme_style = "dimmed",
				function_style = "italic",
				keyword_style = "italic",
			})
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
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.scrolloff = 5 -- Lines of context
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
