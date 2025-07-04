{ config, pkgs, ... }:
let
  nush = pkgs.runCommand "nush" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    ln -s ${pkgs.nushell}/bin/nu $out/bin/nush
    wrapProgram $out/bin/nush --prefix PATH : ${
      pkgs.lib.makeBinPath [ pkgs.nushell ]
    }
  '';
in {
  imports = [
    ./../modules/gnome.nix
    ./../modules/hyprland.nix
    ./../modules/nvim.nix
    ./../modules/audio.nix
  ];
  home.username = "ofrades";
  home.homeDirectory = "/home/ofrades";
  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      strict_env = true;
      whitelist = { prefix = [ "$HOME/dev" ]; };
    };
  };

  home.packages = with pkgs; [
    vim
    wget
    git
    docker
    nodejs
    bun
    pnpm
    biome
    python3
    uv
    zig
    ddcutil
    vlc
    neofetch
    lazygit
    ripgrep
    jq
    tree
    watch
    fd
    htop
    bat
    lazydocker
    jdk
    ollama
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    jetbrains-mono
    networkmanagerapplet
    (flameshot.override { enableWlrSupport = true; })
    nodePackages."@antfu/ni"
    obs-studio
    telegram-desktop
    slack
    whatsapp-for-linux
    obsidian
    inkscape
    krita
    awscli2
    discord
    peek
  ];

  fonts.fontconfig.enable = true;

  programs.fzf.enable = true;

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
      condition = "gitdir:/home/ofrades/dev/neuraspace/";
      contents = {
        user = {
          name = "Miguel Bastos";
          email = "miguel.bastos@neuraspace.com";
        };
      };
    }];
  };

  programs.brave.enable = true;

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
      "theme" = "tokyonight";
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
      "copy-on-select" = "clipboard";
      "confirm-close-surface" = false;
    };
  };

  programs.carapace = {
    enable = false;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.nushell = {
    enable = true;
    package = nush;
    shellAliases = {
      g = "lazygit";
      n = "nvim";
    };
    configFile.text = ''
      $env.config = {
        show_banner: false
        completions: {
          external: {
            enable: true
            max_results: 100
          }
        }
      }
    '';
  };

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      show_tabs = false;
      style = "compact";
    };
  };

  programs.starship.enable = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.home-manager.enable = true;
}
