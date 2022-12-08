vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({ "folke/neodev.nvim", module = "neodev" })
  use({
    "folke/neoconf.nvim",
    module = "neoconf",
    cmd = "Neoconf",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = { "javascript" },
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
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  })

  use({
    "glepnir/dashboard-nvim",
    config = function()
      local home = os.getenv("HOME")
      local db = require("dashboard")

      db.preview_file_path = home .. "/.config/nvim/static/neovim.cat"
      db.custom_header = {
        " ██████╗ ███████╗██████╗  █████╗ ██████╗ ███████╗███████╗",
        "██╔═══██╗██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝",
        "██║   ██║█████╗  ██████╔╝███████║██║  ██║█████╗  ███████╗",
        "██║   ██║██╔══╝  ██╔══██╗██╔══██║██║  ██║██╔══╝  ╚════██║",
        "╚██████╔╝██║     ██║  ██║██║  ██║██████╔╝███████╗███████║",
        " ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝",
      }

      db.custom_center = {
        {
          icon = "  ",
          desc = "Recently latest session                  ",
          shortcut = "SPC s l",
          action = "SessionLoad",
        },
        {
          icon = "  ",
          desc = "Recently opened files                   ",
          action = "Telescope oldfiles",
          shortcut = "SPC f h",
        },
        {
          icon = "  ",
          desc = "Find  File                              ",
          action = "Telescope find_files find_command=rg,--hidden,--files",
          shortcut = "SPC f f",
        },
        {
          icon = "  ",
          desc = "File Browser                            ",
          action = "Telescope file_browser",
          shortcut = "SPC f b",
        },
        {
          icon = "  ",
          desc = "Find  word                              ",
          action = "Telescope live_grep",
          shortcut = "SPC f w",
        },
        {
          icon = "  ",
          desc = "Open Personal dotfiles                  ",
          action = "Telescope dotfiles path=" .. home .. "/dot",
          shortcut = "SPC f d",
        },
      }
    end,
  })
  use({
    "folke/drop.nvim",
    config = function()
      require("drop").setup()
    end,
  })

  use({
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
      vim.api.nvim_set_keymap(
        "n",
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "gpt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "gpi",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "gP",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "gpr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        { noremap = true }
      )
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "mrshmllow/document-color.nvim",
    },
    config = function()
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

      require("document-color").setup({
        mode = "background", -- "background" | "foreground" | "single"
      })

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "gq", vim.diagnostic.setloclist, opts)
      vim.keymap.set("n", "gx", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
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

      local function on_attach(client, bufnr)
        if vim.fn.exists(":Telescope") then
          vim.keymap.set("n", "gr", "<cmd>:Telescope lsp_references theme=ivy<CR>", buf_opts)
          vim.keymap.set("n", "gd", "<cmd>:Telescope lsp_definitions theme=ivy<CR>", buf_opts)
          vim.keymap.set("n", "gD", "<cmd>:Telescope lsp_declarations theme=ivy<CR>", buf_opts)
          vim.keymap.set("n", "gi", "<cmd>:Telescope lsp_implementations theme=ivy<CR>", buf_opts)
          vim.keymap.set("n", "gt", "<cmd>:Telescope lsp_type_definitions theme=ivy<CR>", buf_opts)
        else
          vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts)
          vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, buf_opts)
        end

        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, buf_opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, buf_opts)
        vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, buf_opts)
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, buf_opts)
        vim.keymap.set("n", "gF", vim.lsp.buf.format, buf_opts)
        vim.keymap.set("n", "gh", vim.lsp.buf.hover, buf_opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)

        if client.server_capabilities.documentFormatting then
          vim.keymap.set("n", "gF", vim.lsp.buf.format, buf_opts)
        elseif client.server_capabilities.documentRangeFormatting then
          vim.keymap.set("n", "gF", vim.lsp.buf.range_formatting, buf_opts)
        elseif client.server_capabilities.colorProvider then
          require("document-color").buf_attach(bufnr)
        end
      end

      require("mason").setup()
      local mason_lspconfig = require("mason-lspconfig")
      local capabilities =
      require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local servers = {
        tsserver = {},
        eslint = {},
        jsonls = {},
        pyright = {},
        rust_analyzer = {},
        marksman = {},
        sumneko_lua = {},
      }

      mason_lspconfig.setup({
        ensure_installed = servers,
      })
      capabilities.textDocument.colorProvider = {
        dynamicRegistration = true,
      }
      local options = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
      mason_lspconfig.setup_handlers({
        function(servers)
          if servers == "tsserver" then
            local root_pattern = require("lspconfig.util").root_pattern
            require("typescript").setup({ server = options })
          else
            require("lspconfig")[servers].setup(options)
          end
        end,
      })
    end,
  })

  use({
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
          null_ls.builtins.formatting.jq,
          null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.fixjson,
          null_ls.builtins.formatting.yamlfmt,
          null_ls.builtins.formatting.markdownlint,
        },
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

  use({ "ThePrimeagen/harpoon" })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
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
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("harpoon")
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
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
          },
          follow_current_file = true,
        },
        window = {
          position = "current",
        },
        event_handlers = {

          {
            event = "file_opened",
            handler = function(file_path)
              --auto close
              require("neo-tree").close_all()
            end,
          },
        },
      })
    end,
  })

  use({
    "sindrets/diffview.nvim",
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require("diffview").setup({
        keymaps = {
          file_panel = {
            ["q"] = "<Cmd>tabc<CR>",
          },
        },
      })
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",

    config = function()
      require("gitsigns").setup()
    end,
  })

  use({
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup()
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

  use({
    "folke/tokyonight.nvim",
    requires = {
      "ellisonleao/gruvbox.nvim",
    },
    config = function()
      vim.cmd("colorscheme tokyonight-storm")
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
    "folke/noice.nvim",
    config = function()
      require("noice").setup()
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        config = function()
          local notify = require("notify")
          notify.setup({
            render = "minimal",
            stages = "static",
            timeout = 1000,
          })
        end,
      },
    },
  })

  use({
    "nvim-lualine/lualine.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "SmiteshP/nvim-navic",
      "folke/noice.nvim",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          icons_enabled = true,
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" } } },
          lualine_b = { "branch" },
          lualine_c = {
            { "diagnostics", sources = { "nvim_diagnostic" } },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              function()
                local navic = require("nvim-navic")
                local ret = navic.get_location()
                return ret:len() > 2000 and "navic error" or ret
              end,
              cond = function()
                local navic = require("nvim-navic")
                return navic.is_available()
              end,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_x = {
            -- {
            --   require("noice").api.status.message.get_hl,
            --   cond = require("noice").api.status.message.has,
            -- },
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("noice").api.status.search.get,
              cond = require("noice").api.status.search.has,
              color = { fg = "#ff9e64" },
            },
            -- function()
            --   return require("messages.view").status
            -- end,
            {
              function()
                return require("util.dashboard").status()
              end,
            },
          },
          lualine_y = { "location" },
          lualine_z = { " " .. os.date("%H:%M") },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        -- winbar = {
        --   lualine_a = {},
        --   lualine_b = {},
        --   lualine_c = { "filename" },
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = {},
        -- },
        --
        -- inactive_winbar = {
        --   lualine_a = {},
        --   lualine_b = {},
        --   lualine_c = { "filename" },
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = {},
        -- },
        extensions = { "nvim-tree" },
      })
    end,
  })

  use({
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
  })

  use({ 'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
    config = function()
      require('peek').setup({
        auto_load = true,
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,
        throttle_at = 200000,
        throttle_time = 'auto'
      })
    end
  })

  use({
    "Ostralyan/scribe.nvim",
    config = function()
      require("scribe").setup({})
    end,
  })

  use({
    "petertriho/nvim-scrollbar",
    requires = {
      "kevinhwang91/nvim-hlslens",
    },
    config = function()
      require("scrollbar").setup()
      require("hlslens").setup()
    end,
  })

  use({
    "vim-test/vim-test",
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
    end,
  })

  use({
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-vim-test",
    },
    config = function()
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
          require("neotest-vim-test")({
            ignore_file_types = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          }),
        },
      })
    end,
  })

  use({
    "mfussenegger/nvim-dap",
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "→", texthl = "Error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "", numhl = "" })

      vim.keymap.set("n", "<F1>", [[:lua require('dapui').toggle()<cr>]])
      vim.keymap.set("n", "<F2>", [[:lua require('dap').terminate()<cr>]])

      vim.keymap.set("n", "<F4>", [[:lua require('dap').toggle_breakpoint()<cr>]])
      vim.keymap.set("n", "<F5>", [[:lua require('dap').continue()<cr>]])
      vim.keymap.set("n", "<F6>", [[:lua require('dap').step_over()<cr>]])
      vim.keymap.set("n", "<F7>", [[:lua require('dap').step_into()<cr>]])
      vim.keymap.set("n", "<F9>", [[:lua require('dap').step_out()<cr>]])

      local dap = require("dap")

      dap.set_log_level("TRACE")
    end,
  })

  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup({})
    end,
  })

  use({
    "theHamsta/nvim-dap-virtual-text",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
      vim.g.dap_virtual_text = true
    end,
  })

  use({
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      })
      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "[pwa-node] Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "[pwa-node] Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests ts-node",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "node_modules/.bin/jest",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            skipFiles = { "<node_internals>/**" },
            protocol = "inspector",
          },
        }
      end
    end,
  })

  use({
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
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

-- Out
vim.keymap.set("n", "<ESC><ESC>", ":q!<cr>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set("", "<ESC>", ":noh<cr>")

-- Move to window using the <ctrl> movement keys
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>")

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

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- tree
vim.keymap.set("n", "<leader>e", "<cmd>:Neotree position=left focus toggle<cr>")

vim.keymap.set("n", "<leader>s", "<cmd>:lua require('spectre').open()<cr>")
vim.keymap.set("n", "<leader>o", "<cmd>:Telescope oldfiles hidden=true<cr>")
vim.keymap.set("n", "<leader>p", "<cmd>:Telescope find_files theme=ivy hidden=true<cr>")
vim.keymap.set("n", "<leader>f", "<cmd>:Telescope live_grep<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>:Telescope file_browser theme=ivy hidden=true<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>:q<cr>") -- exit
vim.keymap.set("n", "<leader>w", "<cmd>:w<cr>") -- save
vim.keymap.set("n", "<leader>x", "<cmd>:TroubleToggle<cr>") -- project diagnostics

vim.keymap.set("n", "<leader>d", "<cmd>:e ~/.config/nvim/init.lua<cr>")
vim.keymap.set(
  "n",
  "<leader>.",
  "<cmd>:lua require('telescope.builtin').find_files({cwd = '~/dot', hidden = true})<cr>"
)

vim.keymap.set(
  "n",
  "<leader>m",
  "<cmd>:lua require('telescope').extensions.file_browser.file_browser({cwd = '~/notes'})<cr>"
)
vim.keymap.set("n", "<leader>/", "<cmd>:Telescope current_buffer_fuzzy_find<cr>")

vim.keymap.set("n", "gb", "<cmd>:Gitsigns blame_line<cr>")
vim.keymap.set("n", "gp", "<cmd>:Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "<leader>d", "<cmd>:DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>g", "<cmd>:Lazygit<cr>")

vim.keymap.set("n", "<leader>ha", "<cmd>:lua require('harpoon.mark').add_file()<cr>")
vim.keymap.set("n", "<leader>hm", "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<cr>")
vim.keymap.set("n", "<leader>ho", "<cmd>:lua require('harpoon.ui').nav_prev()<cr>")
vim.keymap.set("n", "<leader>hi", "<cmd>:lua require('harpoon.ui').nav_next()<cr>")
vim.keymap.set("n", "<leader>hh", "<cmd>:Telescope harpoon marks theme=ivy hidden=true<cr>")

vim.keymap.set("n", "<leader>\\", "<cmd>:ToggleTerm direction=float<cr>")
vim.keymap.set("n", "<leader>b", "<cmd>:ToggleTerm direction=horizontal<cr>")
vim.keymap.set("n", "<leader>v", "<cmd>:ToggleTerm direction=vertical<cr>")

vim.keymap.set("n", "tf", "<cmd>:TestFile<cr>")
vim.keymap.set("n", "tl", "<cmd>:TestLast<cr>")
vim.keymap.set("n", "tn", "<cmd>:TestNearest<cr>")
vim.keymap.set("n", "tw", "<cmd>:TestNearest --watch<cr>")
vim.keymap.set("n", "ts", "<cmd>:TestSuite<cr>")

vim.keymap.set("n", "<leader>nn", "<cmd>:lua require('neotest').run.run()<cr>")
vim.keymap.set("n", "<leader>nf", "<cmd>:lua require('neotest').run.run(vim.fn.expand('%'))<cr>")
vim.keymap.set("n", "<leader>nd", "<cmd>:lua require('neotest').run.run({strategy = 'dap'})<cr>")
vim.keymap.set("n", "<leader>nx", "<cmd>:lua require('neotest').run.stop()<cr>")
vim.keymap.set("n", "<leader>na", "<cmd>:lua require('neotest').run.attach()<cr>")
vim.keymap.set("n", "<leader>no", "<cmd>:lua require('neotest').output.open({enter = true})<cr>")
vim.keymap.set("n", "<leader>ns", "<cmd>:lua require('neotest').summary.toggle()<cr>")

vim.keymap.set("n", "f", "<cmd>:HopWord<cr>")

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

-- options
vim.o.updatetime = 250

-- reload when files change outside buffer
vim.o.autoread = true

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
vim.opt.diffopt = { "vertical", "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
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
vim.opt.cmdheight = 1

-- don't load the plugins below
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
end

-- open session in last location
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.format({ async = true })")
vim.cmd("autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll")
