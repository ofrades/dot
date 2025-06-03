{ config, inputs, pkgs, ... }: {

  home.file = {
    ".config/nvim/lua/plugins/plugins.lua" = {
      text = ''
        return {
          {
            "afonsofrancof/worktrees.nvim",
            opts = {
              -- Specify where to create worktrees relative to git common dir
              -- The common dir is the .git dir in a normal repo or the root dir of a bare repo
              base_path = "../..", -- Parent directory of common dir
              -- Template for worktree folder names
              -- This is only used if you don't specify the folder name when creating the worktree
              path_template = "{branch}", -- Default: use branch name
              -- Command names (optional)
              commands = {
                create = "WorktreeCreate",
                delete = "WorktreeDelete",
                switch = "WorktreeSwitch",
              },
              -- Key mappings (optional)
              mappings = {
                create = "<leader>gtc",
                delete = "<leader>gtd",
                switch = "<leader>gts",
              },
            },
          },
          {
            "nvim-lspconfig",
            opts = {
              inlay_hints = { enabled = false },
            },
          },
          {
            "NvChad/nvim-colorizer.lua",
            opts = {
              user_default_options = {
                mode = "background",
                names = false,
              },
            },
          },
          { "echasnovski/mini.pairs", enabled = false },
          { "akinsho/bufferline.nvim", enabled = false },
          { "mg979/vim-visual-multi" },
          {
            "yetone/avante.nvim",
            event = "VeryLazy",
            lazy = false,
            version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
            opts = {
              provider = "ollama",
              ollama = {
                endpoint = "http://127.0.0.1:11434",
                model = "codellama:7b",
              },
            },
            build = "make",
            dependencies = {
              "stevearc/dressing.nvim",
              "nvim-lua/plenary.nvim",
              "MunifTanjim/nui.nvim",
              {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                  file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
              },
            },
          },
          {
            "olimorris/codecompanion.nvim",
            dependencies = {
              "nvim-lua/plenary.nvim",
              "nvim-treesitter/nvim-treesitter",
            },
            opts = {
              --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
              strategies = {
                --NOTE: Change the adapter as required
                chat = { adapter = "ollama" },
                inline = { adapter = "ollama" },
              },
              opts = {
                log_level = "DEBUG",
              },
            },
          },
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
            "nvim-neotest/neotest",
            dependencies = {
              "marilari88/neotest-vitest",
            },
            opts = {
              adapters = {
                ["neotest-vitest"] = {},
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
      '';
    };
    ".config/nvim/lua/config/keymaps.lua" = {
      text = ''
        vim.keymap.set("n", "Y", "y$")
        vim.keymap.set("n", "D", "d$")
        vim.keymap.set("n", "C", "c$")
        vim.keymap.set("n", ";", ":")
        vim.keymap.set("n", "H", "^")
        vim.keymap.set("o", "H", "^")
        vim.keymap.set("x", "H", "^")
        vim.keymap.set("n", "L", "$")
        vim.keymap.set("o", "L", "$")
        vim.keymap.set("x", "L", "$")
        vim.keymap.set("n", "<C-o>", "<C-o>zz")
        vim.keymap.set("n", "<C-i>", "<C-i>zz")
        vim.keymap.set("n", "<leader>tx", "<cmd>:vsplit | term npm run test %<cr>", { desc = "Run test in split" })
        vim.keymap.set("n", "<leader>tX", "<cmd>:vsplit | term npm run test:watch %<cr>", { desc = "Run test watch in split" })
        vim.keymap.set("n", "qq", "<cmd>:q!<cr>", { desc = "Close" })
        vim.keymap.set("n", "tt", "<cmd>:vsplit | term<cr>", { desc = "Terminal" })
        vim.keymap.set("n", "tb", "<cmd>:split | term<cr>", { desc = "Terminal bottom" })
        vim.keymap.set("n", "<M-t>", ':exec &bg=="light" ? "set bg=dark" : "set bg=light"<CR>', { desc = "Toggle bg" })
        vim.keymap.set("n", "<leader>.", "<cmd>:FzfLua files cwd='~/dot'<cr>", { desc = "Dot files" })
        vim.keymap.set("n", "<leader>gf", function()
          Snacks.picker.git_log_file()
        end, { desc = "File commits" })
        vim.keymap.set("n", "<leader>gF", function()
          Snacks.lazygit.log_file()
        end, { desc = "File commits in lazygit" })

        vim.keymap.set("n", "<leader>e", function()
          Snacks.picker.explorer()
        end, { desc = "File explorer" })
      '';
    };

    ".config/nvim/lua/config/options.lua" = {
      text = ''
        vim.o.updatetime = 250

        -- reload when files change outside buffer
        vim.o.autoread = true
        vim.o.shell = "nush"

        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.opt.grepprg = "rg --vimgrep"

        vim.opt.relativenumber = true -- Relative line numbers
        vim.opt.scrolloff = 5 -- Lines of context
        vim.opt.swapfile = false
        vim.g.show_inlay_hints = false

        vim.opt.backup = true
        vim.opt.cmdheight = 0
        vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.o.foldcolumn = "0"

        vim.g.netrw_banner = 0
        vim.g.netrw_keepdir = 0
        vim.g.netrw_liststyle = 1
        vim.o.spelllang = "en,pt,la"
        vim.o.spell = true

        -- macros
        local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
        vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:', " .. esc .. "pa);" .. esc .. "s") -- with sav
      '';
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    vimdiffAlias = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
    extraLuaConfig = ''
      require("lazy").setup({
        spec = {
          -- add LazyVim and import its plugins
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.lang.markdown" },
          { import = "lazyvim.plugins.extras.lang.astro" },
          { import = "lazyvim.plugins.extras.lang.tex" },
          { import = "lazyvim.plugins.extras.lang.nix" },
          { import = "lazyvim.plugins.extras.lang.python" },
          { import = "lazyvim.plugins.extras.test.core" },
          { import = "lazyvim.plugins.extras.dap.core" },
          { import = "lazyvim.plugins.extras.lang.tailwind" },
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.linting.eslint" },
          { import = "lazyvim.plugins.extras.formatting.prettier" },
          { import = "lazyvim.plugins.extras.formatting.biome" },
          { import = "lazyvim.plugins.extras.coding.yanky" },
          { import = "lazyvim.plugins.extras.editor.snacks_picker" },
          { import = "plugins" },
        },
        defaults = {
          -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
          -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
          lazy = false,
          -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
          -- have outdated releases, which may break your Neovim install.
          version = false, -- always use the latest git commit
          -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        install = { colorscheme = { "tokyonight" } },
        checker = {
          enabled = true, -- check for plugin updates periodically
          notify = false, -- notify on update
        }, -- automatically check for plugin updates
        performance = {
          rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
              "gzip",
              -- "matchit",
              -- "matchparen",
              -- "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
  };
}
