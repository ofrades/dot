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
		"neovim/nvim-lspconfig",
		requires = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"jose-elias-alvarez/typescript.nvim",
		},
		config = function()
			require("typescript").setup({})
		end,
	})

	use({
		"kassio/neoterm",
		config = function()
			vim.g.neoterm_default_mod = "botright"
			vim.g["neoterm_autoscroll"] = 1
			vim.g["neoterm_autoinsert"] = 1
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
		"rcarriga/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"haydenmeade/neotest-jest",
			"rcarriga/neotest-python",
			"rcarriga/neotest-vim-test",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest"),
					require("neotest-python"),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
				},
			})
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
		requires = {
			"tpope/vim-rhubarb",
			"kdheepak/lazygit.nvim",
			{
				"lewis6991/gitsigns.nvim",
				config = function()
					require("gitsigns").setup({
						current_line_blame = false,
					})
				end,
			},
		},
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
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			{ "hrsh7th/cmp-copilot", requires = { "github/copilot.vim" } },
			{
				"L3MON4D3/LuaSnip",
				wants = "friendly-snippets",
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
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
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
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
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
			"EdenEast/nightfox.nvim",
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
						-- conditionals = "NONE",
						constants = "bold",
						functions = "italic",
						-- keywords = "NONE",
						-- numbers = "NONE",
						-- operators = "NONE",
						-- strings = "NONE",
						types = "italic,bold",
						-- variables = "NONE",
					},
					inverse = { -- Inverse highlight for different types
						match_paren = false,
						visual = false,
						search = false,
					},
				},
				palettes = {
					nordfox = {
						bg0 = "#282828",
						bg1 = "#282C34",
					},
					nightfox = {
						bg0 = "#282828",
						bg1 = "#282C34",
					},
					duskfox = {
						bg0 = "#282828",
						bg1 = "#282C34",
					},
				},
			})
			vim.cmd([[colorscheme nightfox]])
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
		"Pocco81/dap-buddy.nvim",
		branch = "dev",
		requires = {
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
			"David-Kunz/jester",
		},
		config = function()
			local dap = require("dap")
			local dap_install = require("dap-install")

			dap_install.setup({
				installation_path = os.getenv("HOME") .. "/.local/share/nvim/dapinstall/",
			})

			dap_install.config("jsnode", {})

			require("nvim-dap-virtual-text").setup()

			vim.g.dap_virtual_text = true

			vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

			vim.keymap.set("n", "<leader>dd", function()
				require("jester").debug()
			end)
			vim.keymap.set("n", "<leader>df", function()
				require("jester").debug_file()
			end)
			vim.keymap.set("n", "<leader>dl", function()
				require("jester").debug_last()
			end)
			vim.keymap.set("n", "<leader>dq", function()
				require("jester").terminate()
			end)

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
