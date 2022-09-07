-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

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
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "smjonas/inc-rename.nvim",
    },
    event = "BufReadPre",
    config = function()
      require("inc_rename").setup()
      local tools = {
        "prettierd",
        "stylua",
        "shellcheck",
        "shfmt",
      }
      local mr = require("mason-registry")
      for _, tool in ipairs(tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local wk = require("which-key")
      local function on_attach(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        local keymap = {
          c = {
            name = "+code",
            r = {
              function()
                require("inc_rename").rename({ default = vim.fn.expand("<cword>") })
              end,
              "Rename",
            },
            a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
            d = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
            l = {
              name = "+lsp",
              i = { "<cmd>LspInfo<cr>", "Lsp Info" },
              a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
              r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
              l = {
                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                "List Folders",
              },
            },
          },
          x = {
            d = { "<cmd>Telescope diagnostics<cr>", "Search Diagnostics" },
          },
        }

        if not client.server_capabilities.renameProvider then
          keymap.c.r = nil
        end

        if client.name == "tsserver" then
          keymap.c.o = { "<cmd>:TypescriptOrganizeImports<CR>", "Organize Imports" }
          keymap.c.R = { "<cmd>:TypescriptRenameFile<CR>", "Rename File" }
        end

        local keymap_visual = {
          c = {
            name = "+code",
            a = { ":<C-U>lua vim.lsp.buf.range_code_action()<CR>", "Code Action" },
          },
        }

        local keymap_goto = {
          name = "+goto",
          a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
          d = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
          r = { "<cmd>Telescope lsp_references<cr>", "References" },
          R = {
            function()
              require("inc_rename").rename({ default = vim.fn.expand("<cword>") })
            end,
            "Rename",
          },
          D = { "<Cmd>Telescope lsp_declarations<CR>", "Goto Declaration" },
          s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
          I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
          t = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
        }

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.keymap.set(
          "n",
          "[e",
          "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",
          opts
        )
        vim.keymap.set(
          "n",
          "]e",
          "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",
          opts
        )
        vim.keymap.set(
          "n",
          "[w",
          "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<CR>",
          opts
        )
        vim.keymap.set(
          "n",
          "]w",
          "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<CR>",
          opts
        )

        local trigger_chars = client.server_capabilities.signatureHelpTriggerCharacters
        trigger_chars = { "," }
        for _, c in ipairs(trigger_chars) do
          vim.keymap.set("i", c, function()
            vim.defer_fn(function()
              pcall(vim.lsp.buf.signature_help)
            end, 0)
            return c
          end, {
            noremap = true,
            silent = true,
            buffer = bufnr,
            expr = true,
          })
        end

        if client.server_capabilities.documentFormatting then
          keymap.c.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
        elseif client.server_capabilities.documentRangeFormatting then
          keymap_visual.c.f = { "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format Range" }
        end

        wk.register(keymap, { buffer = bufnr, prefix = "<leader>" })
        wk.register(keymap_visual, { buffer = bufnr, prefix = "<leader>", mode = "v" })
        wk.register(keymap_goto, { buffer = bufnr, prefix = "g" })
      end

      local servers = {
        ansiblels = {},
        bashls = {},
        cssls = {},
        tsserver = {},
        eslint = {},
        html = {},
        jsonls = {},
        pyright = {},
        rust_analyzer = {},
        sumneko_lua = {},
      }

      local capabilities =
      require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

      local options = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }

      for server, opts in pairs(servers) do
        opts = vim.tbl_deep_extend("force", {}, options, opts or {})
        if server == "tsserver" then
          require("typescript").setup({ server = opts })
        else
          require("lspconfig")[server].setup(opts)
        end
      end

      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.fish_indent,
          nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
          -- nls.builtins.formatting.eslint_d,
          -- nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.markdownlint,
          -- nls.builtins.code_actions.gitsigns,
        },
        on_attach = options.on_attach,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
      })
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    config = function()
      vim.o.completeopt = "menuone,noselect"

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
        sorting = {
          comparators = {
            cmp.config.compare.sort_text,
            cmp.config.compare.offset,
            -- cmp.config.compare.exact,
            cmp.config.compare.score,
            -- cmp.config.compare.kind,
            -- cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
    requires = {
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
  })

  use({
    "L3MON4D3/LuaSnip",
    module = "luasnip",
    config = function()
      require("luasnip").setup({})
    end,
    requires = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "ThePrimeagen/harpoon",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      "nvim-telescope/telescope-project.nvim",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-z.nvim",
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
      require("telescope").load_extension("z")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("frecency")
      require("telescope").load_extension("harpoon")
      require("telescope").load_extension("luasnip")
    end,
  })

  use({
    "vim-test/vim-test",
    requires = {
      "akinsho/toggleterm.nvim",
    },
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
          },
        },
      })
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "tpope/vim-rhubarb",
      "sindrets/diffview.nvim",
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

  use({
    "windwp/nvim-autopairs",
    module = "nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("indent_blankline").setup()
    end,
  })

  use({
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup({})
    end,
  })

  use({ "kristijanhusak/vim-carbon-now-sh" })

  use({
    "tpope/vim-repeat",
    "tpope/vim-dispatch",
    "tpope/vim-eunuch",
  })

  use({
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("Comment").setup({})
    end,
  })

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

  use({ "simnalamburt/vim-mundo" })

  use({
    "RRethy/vim-illuminate",
  })

  use({ "stevearc/dressing.nvim" })

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

  use({
    "rmehri01/onenord.nvim",
    config = function()
      vim.cmd([[colorscheme onenord]])
    end,
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
    "phaazon/mind.nvim",
    config = function()
      require("mind").setup()
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
      require("spectre").setup()
    end,
  })

  if is_bootstrap then
    require("packer").sync()
  end
end)

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | PackerCompile",
  group = packer_group,
  pattern = vim.fn.expand("$MYVIMRC"),
})

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

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")

-- Out
vim.keymap.set("n", "<ESC><ESC>", ":q!<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("", "<ESC>", ":noh<cr>")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<cr>")
vim.keymap.set("n", "<C-Down>", ":resize -2<cr>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<cr>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<cr>")

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

-- grep files
vim.keymap.set("n", "<C-p>", "<cmd>:Telescope find_files theme=ivy hidden=true<cr>")

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

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
  t = { "<cmd>:MindOpenMain<cr>", "Notes" },
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
  g = { "<cmd>:Lazygit<cr>", "Lazygit" },
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
  t = { "<cmd>:term<cr>", "Terminal" },
  v = { "<cmd>:vsplit | term<cr>", "Terminal vsplit" },
  b = { "<cmd>:split | term<cr>", "Terminal bottom" },
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
  ["/"] = { "<cmd>:Telescope current_buffer_fuzzy_find theme=ivy<cr>", "Search in file" },
  ["."] = { "<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>", "Dot" },
  ["<leader>"] = { "<cmd>:Telescope commands theme=ivy<cr>", "Commands" },
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
  z = {
    "<cmd>:lua require'telescope'.extensions.z.list{ cmd = { vim.o.shell, '-c', 'zoxide query -sl' } }<CR>",
    "Z",
  },
}, { prefix = "<leader><leader>" })

map.register({
  b = { "<cmd>:'<,'>GBrowse!<cr>", "Path to file" },
  f = { "<cmd>:lua require('spectre').open_visual({select_word=true})<CR>", "Find selected" },
}, { mode = "v", prefix = "<leader>" })

-- options
vim.o.updatetime = 250

-- reload when files change outside buffer
vim.o.autoread = true

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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
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
  if vim.api.nvim_win_get_width(0) < 110 then
    return " %<%t "
  end
  return " %<%f "
end

local function git()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  local branch_name = "   " .. git_status.head .. " "

  return (
      vim.api.nvim_win_get_width(0) > 100 and "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
          or "%#St_gitIcons#" .. added .. changed .. removed
      )
end

local function lsp_diagnostics()
  if not rawget(vim, "lsp") then
    return ""
  end
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

  errors = (errors and errors > 0) and ("%#St_lspError#" .. " " .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and ("%#St_lspWarning#" .. " " .. warnings .. " ") or ""
  hints = (hints and hints > 0) and ("%#St_lspHints#" .. " " .. hints .. " ") or ""
  info = (info and info > 0) and ("%#St_lspInfo#" .. " " .. info .. " ") or ""

  return errors .. warnings .. hints .. info
end

local function lsp_progress()
  if not rawget(vim, "lsp") then
    return ""
  end

  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.api.nvim_win_get_width(0) < 120 or not Lsp then
    return ""
  end

  local msg = Lsp.message or ""
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ""
  local spinners = { "", "" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

  return ("%#St_LspProgress#" .. content) or ""
end

Statusline = {}

Statusline.active = function()
  if vim.api.nvim_win_get_width(0) > 100 then
    return table.concat({
      git(),
      "%=",
      " ",
      getfilename(),
      lsp_diagnostics(),
      "%=",
      "Ln %L, Col %c ",
      "%p%%",
      lsp_progress(),
    })
  end
  return table.concat({
    " ",
    getfilename(),
    "%=",
    "%p%%",
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
]] ,
  false
)

-- open session in last location
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

vim.cmd([[autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll]])
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
