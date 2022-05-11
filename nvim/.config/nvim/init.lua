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

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{ command = "source <afile> | PackerCompile", group = packer_group, pattern = "init.lua" }
)

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jose-elias-alvarez/typescript.nvim",
		},
		config = function()
			require("config.lsp")
      require("typescript").setup{}
		end,
	})

	use({ "kassio/neoterm" })
	use({ "christoomey/vim-tmux-navigator" })
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
				ensure_installed = "all",
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<cr>",
						scope_incremental = "<cr>",
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
				autotag = {
					enable = true,
				},
			})
		end,
	})

	use({
		"tpope/vim-fugitive",
		requires = { "tpope/vim-rhubarb", "junegunn/gv.vim", "rhysd/git-messenger.vim" },
	})
	use({ "tpope/vim-surround" })
	use({ "tpope/vim-repeat" })

  use {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup {
        log_level = 'info',
      }
    end
  }

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
				["go.mod"] = {
					["*.go"] = {
						["alternate"] = "{}_test.go",
					},
					["*_test.go"] = {
						["alternate"] = "{}.go",
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
			"saadparwaiz1/cmp_luasnip",
			{ "hrsh7th/cmp-copilot", requires = { "github/copilot.vim" } },
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
			{
				"windwp/nvim-ts-autotag",
				config = function()
					require("nvim-ts-autotag").setup()
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
				open_on_tab = true,
				hijack_cursor = false,
				update_cwd = true,
				update_focused_file = {
					enable = true,
					update_cwd = true,
					ignore_list = {},
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
					signcolumn = "yes",
					number = true,
					mappings = {
						custom_only = false,
						list = {
							{ key = { "<cr>", "o", "l" }, cb = tree_cb("edit") },
							{ key = "<C-v>", cb = tree_cb("vsplit") },
							{ key = "<C-s>", cb = tree_cb("split") },
							{ key = "<C-t>", cb = tree_cb("tabnew") },
							{ key = "<BS>", cb = tree_cb("close_node") },
							{ key = "<S-cr>", cb = tree_cb("close_node") },
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
		"RRethy/vim-illuminate",
	})

	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	})

	use({ "stevearc/dressing.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"ThePrimeagen/harpoon",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("harpoon")
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
					["n <leader>hp"] = "<cmd>Gitsigns preview_hunk<cr>",
					["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<cr>',
				},
			})
		end,
	})

	use({ "kdheepak/lazygit.nvim" })

	use({
		"ruifm/gitlinker.nvim",
		config = function()
			require("gitlinker").setup()
		end,
	})

	use({ "mg979/vim-visual-multi" })

	use({
		"norcalli/nvim-colorizer.lua",
		requires = {
			"Mofiqul/dracula.nvim",
      "projekt0n/github-nvim-theme"
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

			vim.cmd([[colorscheme github_dimmed]])

			local set_hl = function(group, options)
				local bg = options.bg == nil and "" or "guibg=" .. options.bg
				local fg = options.fg == nil and "" or "guifg=" .. options.fg
				local gui = options.gui == nil and "" or "gui=" .. options.gui

				vim.cmd(string.format("hi %s %s %s %s", group, bg, fg, gui))
			end

			local highlights = {
				{ "StatusLine", { fg = "#aaa", bg = "#ccc" } },
			}

			for _, highlight in ipairs(highlights) do
				set_hl(highlight[1], highlight[2])
			end
		end,
	})

  use {
    "projekt0n/circles.nvim",
    requires = {{"kyazdani42/nvim-web-devicons"}, {"kyazdani42/nvim-tree.lua", opt = true}},
    config = function()
      require("circles").setup()
    end
  }

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
			require("config.which")
		end,
	})

	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

  use({
    "Pocco81/dap-buddy.nvim",
    branch = "dev",
    requires = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      "David-Kunz/jester"
    },
    config = function()
      local dap = require("dap")
      local dap_install = require("dap-install")

      dap_install.setup({
        installation_path = os.getenv('HOME') .. "/.local/share/nvim/dapinstall/",
      })

      dap_install.config('jsnode', {})

      require('nvim-dap-virtual-text').setup()

      vim.g.dap_virtual_text = true

      vim.fn.sign_define('DapBreakpoint', {text='🟥', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointRejected', {text='🟦', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

      vim.keymap.set('n', '<leader>dd', function() require"jester".debug() end)
      vim.keymap.set('n', '<leader>df', function() require"jester".debug_file() end)
      vim.keymap.set('n', '<leader>dl', function() require"jester".debug_last() end)
      vim.keymap.set('n', '<leader>dq', function() require"jester".terminate() end)

      vim.keymap.set("n", "<F1>", [[:lua require('dap').toggle_breakpoint()<cr>]])
      vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
      vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
      vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
      vim.keymap.set("n", "<F8>", [[:lua require('dap').step_out()<cr>]])
    end,
  })

	use({
		"windwp/nvim-spectre",
		config = function()
			require("spectre").setup({
				is_insert_mode = true,
				live_update = true,
				mapping = {
					["toggle_line"] = {
						map = "dd",
						cmd = "<cmd>lua require('spectre').toggle_line()<cr>",
						desc = "toggle current item",
					},
					["enter_file"] = {
						map = "<cr>",
						cmd = "<cmd>lua require('spectre.actions').select_entry()<cr>",
						desc = "goto current file",
					},
					["send_to_qf"] = {
						map = "qq",
						cmd = "<cmd>lua require('spectre.actions').send_to_qf()<cr>",
						desc = "send all item to quickfix",
					},
					["replace_cmd"] = {
						map = "<leader>c",
						cmd = "<cmd>lua require('spectre.actions').replace_cmd()<cr>",
						desc = "input replace vim command",
					},
					["show_option_menu"] = {
						map = "<leader>o",
						cmd = "<cmd>lua require('spectre').show_options()<cr>",
						desc = "show option",
					},
					["run_replace"] = {
						map = "<leader>r",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<cr>",
						desc = "replace all",
					},
					["change_view_mode"] = {
						map = "<leader>v",
						cmd = "<cmd>lua require('spectre').change_view()<cr>",
						desc = "change result view mode",
					},
					["toggle_live_update"] = {
						map = "<leader>u",
						cmd = "<cmd>lua require('spectre').toggle_live_update()<cr>",
						desc = "update change when vim write file.",
					},
					["toggle_ignore_case"] = {
						map = "<leader>i",
						cmd = "<cmd>lua require('spectre').change_options('ignore-case')<cr>",
						desc = "toggle ignore case",
					},
					["toggle_ignore_hidden"] = {
						map = "<leader>h",
						cmd = "<cmd>lua require('spectre').change_options('hidden')<cr>",
						desc = "toggle search hidden",
					},
				},
			})
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- one statusline to rule them all
vim.opt.laststatus = 3
vim.opt.statusline =
	"  %< %{FugitiveHead()}  %f %m %r %w %= Ln %l, Col %c  %{&fileencoding?&fileencoding:&encoding}  "

vim.o.updatetime = 250
-- show diagnostics on hover
-- vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])

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
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.inccommand = "split" -- preview incremental substitute
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.number = true -- Print line number
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.scrolloff = 5 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.swapfile = false
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = false -- Disable line wrap
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
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Out
vim.keymap.set("n", "<ESC><ESC>", ":q!<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("", "<ESC>", ":noh<cr>")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<Up>", ":resize +2<cr>")
vim.keymap.set("n", "<Down>", ":resize -2<cr>")
vim.keymap.set("n", "<Left>", ":vertical resize +2<cr>")
vim.keymap.set("n", "<Right>", ":vertical resize -2<cr>")

-- Move Lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi")
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==")
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi")

-- Easy go to start and end of line
vim.keymap.set("n", "H", "^")
vim.keymap.set("o", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("o", "L", "$")
vim.keymap.set("x", "L", "$")

-- Nice defaults
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "D", "d$")
vim.keymap.set("n", "C", "c$")
vim.keymap.set("n", ";", ":")

-- Copy file path
vim.keymap.set("n", "<leader>y", ":let @+=expand('%:p')<cr>")

-- File tree
vim.keymap.set("n", "<space><space>", "<cmd>:NvimTreeToggle<cr>")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- statusline
--
-- %<                                             trim from here
-- %{fugitive#head()}                             name of the current branch (needs fugitive.vim)
-- %f                                             path+filename
-- %m                                             check modifi{ed,able}
-- %r                                             check readonly
-- %w                                             check preview window
-- %=                                             left/right separator
-- %l/%L,%c                                       rownumber/total,colnumber
-- %{&fileencoding?&fileencoding:&encoding}       file encoding
vim.opt.statusline = '%#Pmenu#   %f %m %r %w %= %< %{FugitiveHead()} |  Ln %l, Col %c  %{&fileencoding?&fileencoding:&encoding}  '
