{ config, inputs, pkgs, ... }: {

  imports = [ inputs.LazyVim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      oil-nvim
      nvim-lspconfig
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
      "options.lua".source = ../nvim/lua/config/options.lua;
      "keymaps.lua".source = ../nvim/lua/config/keymaps.lua;
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
