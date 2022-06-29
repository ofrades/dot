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
	{ command = "source <afile> | PackerSync", group = packer_group, pattern = "plugins.lua" }
)

require("packer").startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
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

			lsp.preset("recommended")
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

					require("null-ls").builtins.diagnostics.eslint_d,
					require("null-ls").builtins.diagnostics.flake8,
					require("null-ls").builtins.diagnostics.write_good,
					require("null-ls").builtins.diagnostics.markdownlint,
					require("null-ls").builtins.diagnostics.ansiblelint,
					require("null-ls").builtins.diagnostics.jsonlint,
					require("null-ls").builtins.diagnostics.golangci_lint,
					-- require("null-ls").builtins.diagnostics.cspell,

					require("null-ls").builtins.code_actions.eslint_d,
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
		"jose-elias-alvarez/typescript.nvim",
		config = function()
			require("typescript").setup({})
		end,
	})

	use({
		"kassio/neoterm",
		config = function()
			vim.g.neoterm_default_mod = "botright"
			vim.g["neoterm_autoscroll"] = 1
			vim.g["neoterm_autojump"] = 1
		end,
	})

	use({ "christoomey/vim-tmux-navigator" })

	use({
		"vim-test/vim-test",
		run = ":UpdateRemotePlugins",
		config = function()
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
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				window = {
					position = "current",
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
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
			})
		end,
	})

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
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
				dashboard.button("<Leader><leader>r", "Project Explorer"),
				dashboard.button("<Leader><leader>p", "Find File"),
				dashboard.button("<Leader><leader>f", "Find Word"),
				dashboard.button("<Leader><leader>o", "Recent Files"),
				dashboard.button(":PackerSync<cr>", "Update plugins"),
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
		"tpope/vim-fugitive",
		requires = {
			"tpope/vim-rhubarb",
			{
				"lewis6991/gitsigns.nvim",
				config = function()
					require("gitsigns").setup()
				end,
			},
			{
				"TimUntersberger/neogit",
				config = function()
					require("neogit").setup({})
				end,
			},
		},
	})

	use({ "kristijanhusak/vim-carbon-now-sh" })
	use({ "s-u-d-o-e-r/vim-ray-so-beautiful" })

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
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
	})

	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
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
			"nvim-telescope/telescope-project.nvim",
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
				extensions = {
					project = {
						base_dirs = {
							{ "~/dev", max_depth = 4 },
							{ "~/dot" },
						},
						hidden_files = true,
						theme = "ivy",
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
		end,
	})

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

	use({ "mg979/vim-visual-multi" })

	use({
		"norcalli/nvim-colorizer.lua",
		requires = {
			"~/dev/ofrades/nightfox.nvim",
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

			require("nightfox").setup({
				options = {
					transparent = false, -- Disable setting background
					terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
					dim_inactive = true, -- Non focused panes set to alternative background
					styles = { -- Style to be applied to different syntax groups
						comments = "italic", -- Value is any valid attr-list value `:help attr-list`
						conditionals = "bold",
						constants = "bold",
						functions = "italic",
						keywords = "NONE",
						numbers = "NONE",
						operators = "NONE",
						strings = "italic",
						types = "italic,bold",
						variables = "NONE",
					},
					inverse = { -- Inverse highlight for different types
						match_paren = false,
						visual = false,
						search = false,
					},
				},
				palettes = {
					-- 	nordfox = {
					-- 		bg0 = "#222522",
					-- 		bg1 = "#282C34",
					-- 	},
					-- 	nightfox = {
					-- 		bg0 = "#222522",
					-- 		bg1 = "#282C34",
					-- 	},
					-- duskfox = {
					-- 	bg0 = "#222522",
					-- 	bg1 = "#282C34",
					-- },
				},
				groups = {
					all = {
						TelescopeNormal = { bg = "bg1" },
						TelescopeBorder = { bg = "bg1" },
					},
				},
			})
			vim.cmd([[colorscheme eppzfox]])
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
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

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
			local dap = require("dap")
			require("config.dap")
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
