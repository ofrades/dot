-- neovim configurations 🍃

-- plugins 👇
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
	{ command = "source <afile> | PackerSync", group = packer_group, pattern = "init.lua" }
)

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/nvim-lsp-installer" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local lsp = require("lsp-zero")

			lsp.set_preferences({
				suggest_lsp_servers = true,
				setup_servers_on_start = true,
				set_lsp_keymaps = false,
				configure_diagnostics = true,
				cmp_capabilities = true,
				manage_nvim_cmp = true,
				call_servers = "local",
				sign_icons = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "",
				},
			})
			lsp.setup()

			local luasnip = require("luasnip")

			require("luasnip/loaders/from_vscode").load()
			require("luasnip.loaders.from_vscode").load({ paths = { "~/.config/nvim/lua/config/snippets" } })
			luasnip.filetype_extend("typescript", { "javascript" })
			luasnip.filetype_extend("typescriptreact", { "javascriptreact" })
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").setup({
				sources = {
					require("null-ls").builtins.formatting.prettier.with({
						filetypes = { "html", "json", "yaml", "markdown", "toml" },
					}),
					require("null-ls").builtins.formatting.stylua,
					require("null-ls").builtins.formatting.eslint_d,
					require("null-ls").builtins.formatting.terraform_fmt,
					require("null-ls").builtins.formatting.black,
					require("null-ls").builtins.formatting.fixjson,
					require("null-ls").builtins.formatting.rustfmt,
					require("null-ls").builtins.diagnostics.actionlint,
					-- require("null-ls").builtins.formatting.deno_fmt,

					-- require("null-ls").builtins.diagnostics.eslint_d,
					require("null-ls").builtins.diagnostics.flake8,
					require("null-ls").builtins.diagnostics.write_good,
					require("null-ls").builtins.diagnostics.markdownlint,
					require("null-ls").builtins.diagnostics.ansiblelint,
					require("null-ls").builtins.diagnostics.jsonlint,
					require("null-ls").builtins.diagnostics.golangci_lint,
					-- require("null-ls").builtins.diagnostics.cspell,

					-- require("null-ls").builtins.code_actions.eslint_d,
					require("null-ls").builtins.code_actions.refactoring,

					require("null-ls").builtins.hover.dictionary,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	})

	use({
		"akinsho/toggleterm.nvim",
		requires = {
			"vim-test/vim-test",
		},

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
	})

	use({
		"vim-test/vim-test",
		run = ":UpdateRemotePlugins",
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
			vim.g["test#javascript#jest#options"] = {
				nearest = "--watch",
				file = "--watch",
				suite = "--bail",
			}
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
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				window = {
					position = "float",
				},
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = true, -- only works on Windows for hidden files/directories
						hide_by_name = {
							--"node_modules"
						},
						hide_by_pattern = { -- uses glob style patterns
							--"*.meta"
						},
						never_show = { -- remains hidden even if visible is toggled to true
							--".DS_Store",
							--"thumbs.db"
						},
					},
				},
			})
		end,
	})

	use({
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local function footer()
				local plugins = #vim.tbl_keys(packer_plugins)
				local v = vim.version()
				local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
				local platform = ""
				return string.format(
					" %d   v%d.%d.%d %s  %s",
					plugins,
					v.major,
					v.minor,
					v.patch,
					platform,
					datetime
				)
			end

			-- header
			dashboard.section.header.val = {
				"                                       ",
				"               @@@@@       88888       ",
				"    %%%%%    @@@@@@@@@   888888888     ",
				"  %%%%%%%%% @@@@@@@@@@@ 88888888888    ",
				" %%%%%%%%%%%@@@@@@@@@@@ 88888888888   /",
				" %%%%%%%%%%% @@@@@@@@@   888888888   //",
				"  %%%%%%%%%   @@@@@@@     8888888   /__",
				"   %%%%%%%      |.|         |.|    |   ",
				"     |.|        |.|         |.|    |   ",
				"     |.|        |.|         |.|    |   ",
				"____/..|_______/..|________/..|____|___",
				"                                       ",
			}

			dashboard.section.buttons.val = {
				dashboard.button("<Leader>e", "Tree explorer"),
				dashboard.button("<Leader><leader>o", "Recent Files"),
				dashboard.button("<Leader><leader>p", "Find File"),
				dashboard.button("<Leader><leader>r", "Find project"),
				dashboard.button("<Leader><leader>f", "Find Word"),
				dashboard.button("<Leader>gg", "Lazygit", ":Lazygit<cr>"),
				dashboard.button("q", "Quit", ":qa<cr>"),
			}

			-- footer
			dashboard.section.footer.val = footer()
			dashboard.section.footer.opts.hl = dashboard.section.header.opts.hl

			-- quote
			table.insert(dashboard.config.layout, { type = "padding", val = 1 })
			table.insert(dashboard.config.layout, {
				type = "text",
				val = require("alpha.fortune")(),
				opts = {
					position = "center",
					hl = "AlphaQuote",
				},
			})

			alpha.setup(dashboard.opts)
		end,
	})

	use({
		"is0n/fm-nvim",
		config = function()
			require("fm-nvim").setup({
				ui = {
					-- Default UI (can be "split" or "float")
					default = "float",
					float = {
						height = 1,
						width = 1,
					},
				},
			})
		end,
	})

	use({
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup()
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"tpope/vim-rhubarb",
			{
				"akinsho/git-conflict.nvim",
				config = function()
					require("git-conflict").setup()
				end,
			},
		},
		config = function()
			require("gitsigns").setup()
		end,
	})

	use({ "kristijanhusak/vim-carbon-now-sh" })

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
	use({ "tpope/vim-eunuch" })

	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	})

	use({ "simnalamburt/vim-mundo" })

	use({
		"RRethy/vim-illuminate",
	})

	use({ "stevearc/dressing.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"ThePrimeagen/harpoon",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			"nvim-telescope/telescope-project.nvim",
			"benfowler/telescope-luasnip.nvim",
			{ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" } },
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<ESC>"] = actions.close,
						},
					},
				},
				extensions = {
					project = {
						base_dirs = {
							{ "~/dev", max_depth = 4 },
						},
						hidden_files = true,
						theme = "ivy",
					},
					file_browser = {
						previewer = false,
					},
				},
				pickers = {
					find_files = {
						theme = "ivy",
					},
					oldfiles = {
						theme = "ivy",
					},
					commands = {
						theme = "ivy",
					},
					live_grep = {
						theme = "ivy",
					},
				},
			})
			require("telescope").load_extension("project")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("frecency")
			require("telescope").load_extension("harpoon")
			require("telescope").load_extension("luasnip")
		end,
	})
	use({
		"lalitmee/browse.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("browse").setup({
				provider = "google",
			})
		end,
	})

	use({
		"declancm/cinnamon.nvim",
		config = function()
			require("cinnamon").setup()
		end,
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		config = function()
			require("refactoring").setup({})
		end,
	})

	use({ "mg979/vim-visual-multi" })

	-- themes
	use({
		"~/dev/ofrades/nightfox.nvim",
		requires = {
			"rmehri01/onenord.nvim",
			"shaunsingh/nord.nvim",
			"projekt0n/github-nvim-theme",
		},
	})

	use({
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
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

	use({ "folke/which-key.nvim" })

	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-vim-test",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-vim-test"),
				},
			})
		end,
	})

	use({
		"mfussenegger/nvim-dap",
		requires = {
			{
				"theHamsta/nvim-dap-virtual-text",
				requires = { "mfussenegger/nvim-dap" },
				config = function()
					require("nvim-dap-virtual-text").setup()
					vim.g.dap_virtual_text = true
				end,
			},
			"mfussenegger/nvim-dap-python",
			{
				"rcarriga/nvim-dap-ui",
				requires = { "mfussenegger/nvim-dap" },
				config = function()
					require("dapui").setup({})
				end,
			},
		},
		config = function()
			-- dap
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

			vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

			vim.keymap.set("n", "<F4>", [[:lua require('dap').toggle_breakpoint()<cr>]])
			vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
			vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
			vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
			vim.keymap.set("n", "<F8>", [[:lua require('dap').step_out()<cr>]])

			vim.keymap.set("n", "<F1>", [[:lua require('dapui').toggle()<cr>]])
			vim.keymap.set("n", "<F2>", [[:lua require('jester').debug()<cr>]])

			local dap = require("dap")

			dap.set_log_level("TRACE")

			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/vscode-node-debug2/out/src/nodeDebug.js" },
			}
			dap.configurations.typescript = {
				{
					type = "node2",
					request = "launch",
					name = "Launch Program (Node2 with ts-node)",
					cwd = vim.fn.getcwd(),
					runtimeArgs = { "-r", "ts-node/register" },
					runtimeExecutable = "node",
					args = { "--inspect", "${file}" },
					sourceMaps = true,
					skipFiles = { "<node_internals>/**", "node_modules/**" },
				},
				{
					type = "node2",
					request = "launch",
					name = "Launch Test Program (Node2 with jest)",
					cwd = vim.fn.getcwd(),
					runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
					runtimeExecutable = "node",
					args = { "${file}", "--runInBand", "--coverage", "false" },
					sourceMaps = true,
					port = 9229,
					skipFiles = { "<node_internals>/**", "node_modules/**" },
				},
				{
					type = "node2",
					request = "attach",
					name = "Attach Program (Node2 with ts-node)",
					cwd = vim.fn.getcwd(),
					runtimeExecutable = "node",
					args = { "--inspect", "${file}" },
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
					port = 9229,
				},
			}
		end,
	})

	use({
		"windwp/nvim-spectre",
		config = function()
			require("spectre").setup({
				open_cmd = "tab",
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

-- keymaps
--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- lsp override <C-k>
vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help)

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
vim.keymap.set("n", "<C-a>", "ggVG")

vim.keymap.set("n", "<C-t>", "<cmd>:term<cr>")

-- Copy file path
vim.keymap.set("n", "<leader>yp", ":let @+=expand('%:p')<cr>")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Honky <C-i>
-- vim.keymap.set("n", "<Tab>", "%", { remap = true })
-- vim.keymap.set("x", "<Tab>", "%", { remap = true })
-- vim.keymap.set("o", "<Tab>", "%", { remap = true })
vim.keymap.set("n", "<C-t>", "<cmd>:tabnew<cr>")

-- remap fugitive inline diff to tab
vim.cmd("autocmd FileType fugitive nmap <buffer> <Tab> =")

-- which
local map = require("which-key")
local presets = require("which-key.plugins.presets")

presets.objects["a("] = nil

map.setup({
	show_help = true,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

map.register({
	a = { "<cmd>:lua require('browse').input_search()<cr>", "Browse web" },
	A = { "<cmd>:lua require('browse.devdocs').search_with_filetype()<cr>", "Browse devdocs" },
	b = { "<cmd>:ToggleTerm direction=horizontal<cr>", "Terminal bottom" },
	F = { "<cmd>:ToggleTerm direction=float<cr>", "Terminal bottom" },
	t = { "<cmd>:ToggleTerm direction=tab<cr>", "Terminal bottom" },
	v = { "<cmd>:ToggleTerm direction=vertical<cr>", "Terminal side" },
	e = { "<cmd>:Neotree toggle reveal<CR>", "Tree sidebar" },
	n = { "<cmd>:vsplit | enew<cr>", "New File" },
	q = { "<cmd>:q<cr>", "Quit" },
	u = { "<cmd>:MundoToggle<cr>", "Undo tree" },
	x = { "<cmd>:TroubleToggle<cr>", "Trouble" },
	w = { "<cmd>:w<cr>", "Save" },
	f = { "<cmd>:lua require('spectre').open()<CR>", "Search" },
	F = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Search selected" },
	d = { "<cmd>:e ~/.config/nvim/init.lua<CR>", "Neovim configuration" },
	g = {
		name = "+git",
		b = { "<cmd>:GBrowse<cr>", "Open repo in browser" },
		g = { "<cmd>:Lazygit<cr>", "Lazygit" },
		t = { "<cmd>:Neotree git_status<cr>", "Neotree git_status" },
		m = {
			name = "+mob",
			s = { "<cmd>:T mob start<cr>", "Mob start" },
			n = { "<cmd>:T mob next<cr>", "Mob next" },
			t = { ":T mob timer ", "Mob timer..." },
			d = { "<cmd>:T mob done<cr>", "Mob done" },
			r = { "<cmd>:T mob reset<cr>", "Mob reset" },
			m = { "<cmd>:T mob moo<cr>", "Mob moo!" },
		},
	},
	h = {
		name = "+harpoon",
		a = { "<cmd>:lua require('harpoon.mark').add_file()<cr>", "Add" },
		m = { "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>", "Menu" },
		p = { "<cmd>:lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
		n = { "<cmd>:lua require('harpoon.ui').nav_next()<cr>", "Next" },
	},
}, { prefix = "<leader>" })

map.register({
	a = { "<cmd>:A<cr>", "Toggle test/source file" },
	f = { "<cmd>:TestFile<cr>", "Test File" },
	l = { "<cmd>:TestLast<cr>", "Test Last" },
	c = { "<cmd>:TestNearest<cr>", "Test Nearest" },
	s = { "<cmd>:TestSuite<cr>", "Test Suite" },
	t = { "<cmd>:tab term<cr>", "Terminal" },
	j = {
		name = "+jester",
		r = { "<cmd>:lua require'jester'.run()<cr>", "Run" },
		f = { "<cmd>:lua require'jester'.run_file()<CR>", "Run test file" },
		l = { "<cmd>:lua require'jester'.run_last()<CR>", "Run last test" },
		d = { "<cmd>:lua require'jester'.debug()<CR>", "Debug" },
		F = { "<cmd>:lua require'jester'.debug_file()<CR>", "Debug file" },
		L = { "<cmd>:lua require'jester'.debug_last()<CR>", "Debug last" },
	},
	n = {
		name = "+neotest",
		c = { "<cmd>:lua require'neotest'.run.run()<cr>", "Run nearest test" },
		f = { "<cmd>:lua require'neotest'.run.run(vim.fn.expand('%'))<CR>", "Run test file" },
		d = { "<cmd>:lua require'neotest'.run.run({strategy = 'dap'})<CR>", "Debug nearest test" },
		s = { "<cmd>:lua require'neotest'.run.run(vim.fn.getcwd())<CR>", "Run test suite" },
		S = { "<cmd>:lua require'neotest'.run.stop()<CR>", "Stop nearest test" },
		a = { "<cmd>:lua require'neotest'.run.attach()<CR>", "Attach nearest test" },
		o = { "<cmd>:lua require'neotest'.output.open()<CR>", "Open output" },
		t = { "<cmd>:lua require'neotest'.summary.toggle()<CR>", "Toggle summary" },
	},
	d = {
		name = "+dap",
		b = { "<cmd>:lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>:lua require'dap'.continue()<CR>", "Continue" },
		o = { "<cmd>:lua require'dap'.step_over()<CR>", "Step over" },
		i = { "<cmd>:lua require'dap'.step_into()<CR>", "Step into" },
		t = { "<cmd>:lua require'dapui'.toggle()<CR>", "Toggle ui" },
	},
}, { prefix = "t" })

map.register({
	b = { "<cmd>:Telescope git_branches theme=ivy<cr>", "Git branches" },
	c = { "<cmd>:Telescope commands theme=ivy<cr>", "Commands" },
	f = { "<cmd>:Telescope live_grep theme=ivy hidden=true<cr>", "Find Text" },
	o = { "<cmd>:Telescope oldfiles theme=ivy hidden=true theme=ivy<cr>", "Recent Files" },
	h = { "<cmd>:Telescope help_tags theme=ivy<cr>", "Help" },
	k = { "<cmd>:Telescope keymaps theme=ivy<cr>", "Keymaps" },
	m = { "<cmd>:Telescope man_pages theme=ivy<cr>", "Man pages" },
	p = { "<cmd>:Telescope find_files theme=ivy hidden=true<cr>", "Find Files" },
	P = { "<cmd>:Telescope frecency hidden=true theme=ivy<cr>", "Find Files frecency" },
	r = { "<cmd>:Telescope project theme=ivy<cr>", "Projectile" },
	e = { "<cmd>:Telescope file_browser theme=ivy hidden=true<cr>", "File browser" },
	l = { "<cmd>:Telescope luasnip theme=ivy hidden=true<cr>", "Snippets" },
}, { prefix = "<leader><leader>" })

map.register({
	b = { "<cmd>:'<,'>GBrowse!<cr>", "Path to file" },
	f = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Find selected" },
}, { mode = "v", prefix = "<leader>" })

-- options
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

vim.o.updatetime = 250
-- show diagnostics on hover
-- vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- reload when files change outside buffer
vim.o.autoread = true
vim.cmd([[ au FocusGained,BufEnter * checktime ]])

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.opt.backup = false -- creates a backupt file
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hlsearch = true -- Search highlight
vim.opt.ignorecase = true -- Ignore case
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
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
vim.opt.undofile = true -- save undos per buffer
vim.opt.undolevels = 10000
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = false -- Disable line wrap
vim.g.python_host_prog = "/usr/bin/python"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.opt.shell = "fish"
vim.o.fileencoding = "utf-8"
vim.o.swapfile = false
vim.wo.foldcolumn = "1"
vim.wo.foldlevel = 99 -- feel free to decrease the value
vim.wo.foldenable = true

-- vim.cmd("language en_US.utf-8")

-- don't load the plugins below
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1

-- statusline
local function getfilename()
	if vim.api.nvim_win_get_width(0) < 100 then
		return " %<%t "
	end
	return " %<%f "
end

local function getBranch()
	local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }

	if vim.api.nvim_win_get_width(0) < 160 then
		return ""
	end
	return string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
end

Statusline = {}

Statusline.active = function()
	return table.concat({
		"%#Pmenu# ",
		" ",
		getfilename(),
		"%m",
		"%#Normal#",
		"%=",
		getBranch(),
	})
end

function Statusline.inactive()
	return table.concat({
		"%#Normal# ",
		" ",
		getfilename(),
	})
end

vim.api.nvim_exec(
	[[
	augroup Statusline
	au!
	au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
	au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
	augroup END
]],
	false
)

-- lsp keymaps

vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", "<cmd>:Telescope lsp_definitions theme=ivy<cr>")
vim.keymap.set("n", "gh", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)

vim.keymap.set("n", "gx", "<cmd> lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
vim.keymap.set("n", "gr", "<cmd>:Telescope lsp_references theme=ivy<cr>")
vim.keymap.set("n", "gf", vim.lsp.buf.formatting)

vim.cmd([[colorscheme onenord]])
