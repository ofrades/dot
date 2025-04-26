{ config, inputs, pkgs, ... }: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''

      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
          vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
          }, true, {})
          vim.fn.getchar()
          os.exit(1)
        end
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
            -- add LazyVim and import its plugins
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "lazyvim.plugins.extras.lang.json" },
            { import = "lazyvim.plugins.extras.lang.markdown" },
            { import = "lazyvim.plugins.extras.test.core" },
            { import = "lazyvim.plugins.extras.dap.core" },
            { import = "lazyvim.plugins.extras.lang.tailwind" },
            { import = "lazyvim.plugins.extras.lang.typescript" },
            { import = "lazyvim.plugins.extras.linting.eslint" },
            { import = "lazyvim.plugins.extras.formatting.prettier" },
            { import = "lazyvim.plugins.extras.coding.yanky" },
            { import = "lazyvim.plugins.extras.editor.snacks_picker" },
            {
              "nvim-lspconfig",
              opts = {
                inlay_hints = { enabled = false },
              },
            },
            { "echasnovski/mini.pairs", enabled = false },
            { "nvim-neo-tree/neo-tree.nvim", enabled = false },
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
              "mikavilpas/yazi.nvim",
              event = "VeryLazy",
              keys = {
                -- 👇 in this section, choose your own keymappings!
                {
                  "leader>-",
                  "<cmd>Yazi<cr>",
                  desc = "Open yazi at the current file",
                },
                {
                  -- Open in the current working directory
                  "<leader>cw",
                  "<cmd>Yazi cwd<cr>",
                  desc = "Open the file manager in nvim's working directory",
                },
                {
                  "<c-up>",
                  "<cmd>Yazi toggle<cr>",
                  desc = "Resume the last yazi session",
              },
            },
            opts = {
              open_for_directories = false,
              keymaps = {
                show_help = "<f1>",
              },
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
        install = { colorscheme = { "tokyonight", "habamax" } },
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

      -- keymaps

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


      -- options
      vim.o.updatetime = 250

      -- reload when files change outside buffer
      vim.o.autoread = true
      vim.o.shell = "nu"

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
}
