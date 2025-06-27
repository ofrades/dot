{ config, inputs, pkgs, ... }: {

  imports = [ inputs.LazyVim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      oil-nvim
      nvim-lspconfig
      avante-nvim
      codecompanion-nvim 
      dressing-nvim
      neotest-vitest
      nvim-colorizer-lua 
      nvim-web-devicons
      vim-visual-multi 
    ];
    extras = {
      coding = { yanky.enable = true; };

      lang = {
        json.enable = true;
        markdown.enable = true;
        astro.enable = true;
        nix.enable = true;
        python.enable = true;
        tailwind.enable = true;
        typescript.enable = true;
      };
      test = { core.enable = true; };
      dap = { core.enable = true; };
      linting = { eslint.enable = true; };
      formatting = { prettier.enable = true; };

      editor = {
        dial.enable = true;
        snacks_picker.enable = true;

        inc-rename.enable = true;
      };

      util = {
        dot.enable = true;

        mini-hipatterns.enable = true;
      };
    };
    pluginsFile = {
      "plugins.lua".source = ../nvim/lua/plugins/plugins.lua;
    };
  };

  home.file = {
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
  };
}
