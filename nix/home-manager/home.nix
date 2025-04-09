{ config, pkgs, ... }:

{
  home.username = "ofrades";
  home.homeDirectory = "/home/ofrades";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    neofetch
    lazygit
    nodejs
    ripgrep
    docker
    fd
    bat
    lazydocker
    python3
    jdk
  ];
  programs.neovim.enable = true;
  programs.git = {
    enable = true;
    userName = "ofrades";
    userEmail = "ofrades@pm.me";
    extraConfig = {
      pull.rebase = true;
      push.default = "current";
      diff.tool = "meld";
      difftool.prompt = false;
      difftool.meld.cmd = ''meld "$REMOTE" "$LOCAL"'';
      merge.tool = "meld";
      mergetool.meld.cmd =
        ''meld "$REMOTE" "$MERGED" "$LOCAL" --output "$MERGED"'';
      commit.template = "/home/ofrades/.git-commit-message.txt";
      color.ui = true;
      core.editor = "nvim";
      core.excludesfile = "/home/ofrades/.gitignore_global";
    };
    includes = [{
      condition = "gitdir:~/dev/neuraspace/";
      contents = {
        user = {
          name = "Miguel Bastos";
          email = "miguel.bastos@neuraspace.com";
        };
      };
    }];
  };
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;
    shellAliases = {
      g = "lazygit";
      n = "nvim";
    };
    configFile = {
      text = ''
        $env.config.buffer_editor = "nvim";
        $env.config.show_banner = false;
        $env.config.completions.external.enable = true
        $env.PATH = ($env.PATH | prepend "/nix/var/nix/profiles/default/bin" | prepend "/home/ofrades/.nix-profile/bin")
      '';
    };
  };
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      command = "${pkgs.nushell}/bin/nu";
      "window-decoration" = false;
      "cursor-style" = "block";
      "font-size" = 10;
      "background-opacity" = 0.9;
      "theme" = "dark:catppuccin-frappe,light:catppuccin-latte";
      keybind = [
        "ctrl+a>c=new_tab"
        "ctrl+a>n=next_tab"
        "ctrl+a>p=previous_tab"
        "ctrl+a>z=toggle_split_zoom"
        "ctrl+a>v=new_split:right"
        "ctrl+a>s=new_split:down"
        "ctrl+a>r=reload_config"
        "ctrl+a>1=goto_tab:1"
        "ctrl+a>2=goto_tab:2"
        "ctrl+a>3=goto_tab:3"
        "ctrl+a>4=goto_tab:4"
        "ctrl+a>5=goto_tab:5"
        "ctrl+a>j=goto_split:bottom"
        "ctrl+a>k=goto_split:top"
        "ctrl+a>h=goto_split:previous"
        "ctrl+a>l=goto_split:next"
        "alt+shift+up=resize_split:up,10"
        "alt+shift+down=resize_split:down,10"
        "alt+shift+left=resize_split:left,10"
        "alt+shift+right=resize_split:right,10"
        "ctrl+a>w=close_surface"
      ];
      "gtk-single-instance" = true;
      "gtk-tabs-location" = "bottom";
      "copy-on-select" = "clipboard";
      "confirm-close-surface" = false;
    };
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.home-manager.enable = true;
}
