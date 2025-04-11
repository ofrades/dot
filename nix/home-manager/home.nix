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
    fzf
    rofi
    flameshot
    xorg.setxkbmap
    xorg.xkbcomp
    clipmenu
    clipnotify
    xclip
    ollama
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    i3-gaps
    i3status
    i3lock
    brightnessctl
    polkit_gnome
    networkmanagerapplet
    nodePackages.pnpm
    feh
    picom
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    ".config/nvim".source = ../../nvim/.config/nvim;

    ".local/share/xsessions/i3-nix.desktop" = {
      text = ''
        [Desktop Entry]
        Name=i3 (Nix)
        Comment=Improved tiling window manager installed via Nix
        Exec=${pkgs.i3}/bin/i3
        TryExec=${pkgs.i3}/bin/i3
        Type=Application
        DesktopNames=i3
      '';
      executable = true;
    };

    ".local/bin/power-menu" = {
      text = ''
        #!/bin/bash
        choice=$(echo -e "Logout\nShutdown\nRestart" | rofi -dmenu -p "Power")
        case $choice in
          Logout) i3-msg exit ;;
          Shutdown) systemctl poweroff ;;
          Restart) systemctl reboot ;;
        esac
      '';
      executable = true;
    };
    ".config/picom/picom.conf" = {
      text = ''
        # Basic picom configuration
        backend = "glx";  # Use GLX backend (usually works well with X11)
        vsync = true;     # Prevent screen tearing
        blur-background = false;  # Disable blur by default (optional)
        opacity-rule = [ ];  # You can add specific opacity rules here if needed

        # Shadow settings (optional)
        shadow = true;
        shadow-radius = 7;
        shadow-offset-x = -7;
        shadow-offset-y = -7;

        # Fading (optional)
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
      '';
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout "us,pt" -option "grp:win_space_toggle,caps:escape"
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        menu = "rofi -show drun";
        fonts = {
          names = [ "JetBrains Mono" ];
          size = 10.0;
        };
        gaps = {
          inner = 10;
          outer = 0;
          smartGaps = false;
        };
        keybindings =
          let modifier = config.xsession.windowManager.i3.config.modifier;
          in {
            "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+b" = "split h";
            "${modifier}+v" = "split v";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";
            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+space" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+e" =
              "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";
            "Print" = "exec gnome-screenshot";
            "${modifier}+Print" = "exec gnome-screenshot -a";
            "${modifier}+c" = "exec clipmenu";
            "${modifier}+Shift+s" = "exec flameshot gui";
            "${modifier}+Shift+p" =
              "exec ${config.home.homeDirectory}/.local/bin/power-menu";
            "XF86AudioRaiseVolume" =
              "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" =
              "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessUp" =
              "exec --no-startup-id brightnessctl set +5%";
            "XF86MonBrightnessDown" =
              "exec --no-startup-id brightnessctl set 5%-";
            "${modifier}+r" = "mode resize";
          };
        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Return" = "mode default";
            "Escape" = "mode default";
            "${config.xsession.windowManager.i3.config.modifier}+r" =
              "mode default";
          };
        };
        bars = [{
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          colors = {
            background = "#282a36";
            statusline = "#f8f8f2";
            separator = "#44475a";
            focusedWorkspace = {
              border = "#44475a";
              background = "#44475a";
              text = "#f8f8f2";
            };
            activeWorkspace = {
              border = "#282a36";
              background = "#282a36";
              text = "#f8f8f2";
            };
            inactiveWorkspace = {
              border = "#282a36";
              background = "#282a36";
              text = "#6272a4";
            };
            urgentWorkspace = {
              border = "#ff5555";
              background = "#ff5555";
              text = "#f8f8f2";
            };
            bindingMode = {
              border = "#ff5555";
              background = "#ff5555";
              text = "#f8f8f2";
            };
          };
        }];
        startup = [
          {
            command =
              "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            notification = false;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            notification = false;
          }
          {
            command = "${pkgs.picom}/bin/picom --daemon";
            notification = false;
            always = true;
          }
          {
            command = "${pkgs.picom}/bin/picom --daemon";
            notification = false;
            always = true;
          }
          {
            command = "clipmenud";
            notification = false;
          }
          {
            command =
              "${pkgs.feh}/bin/feh --bg-fill ${config.home.homeDirectory}/dot/wallpaper.png";
            notification = false;
            always = true;
          }
        ];
        window.commands = [
          {
            command = "floating enable";
            criteria = { window_role = "pop-up"; };
          }
          {
            command = "floating enable";
            criteria = { window_role = "bubble"; };
          }
          {
            command = "floating enable";
            criteria = { window_role = "task_dialog"; };
          }
          {
            command = "floating enable";
            criteria = { window_role = "Preferences"; };
          }
          {
            command = "floating enable";
            criteria = { window_type = "dialog"; };
          }
          {
            command = "floating enable";
            criteria = { window_type = "menu"; };
          }
        ];
      };
    };
  };

  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 5;
    };
    modules = {
      "wireless _first_" = {
        position = 1;
        settings = {
          format_up = "W: (%quality at %essid) %ip";
          format_down = "W: down";
        };
      };
      "ethernet _first_" = {
        position = 2;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };
      "battery all" = {
        position = 3;
        settings = { format = "%status %percentage %remaining"; };
      };
      "disk /" = {
        position = 4;
        settings = { format = "%avail"; };
      };
      "load" = {
        position = 5;
        settings = { format = "%1min"; };
      };
      "memory" = {
        position = 6;
        settings = {
          format = "%used | %available";
          threshold_degraded = "1G";
          format_degraded = "MEMORY < %available";
        };
      };
      "tztime local" = {
        position = 7;
        settings = { format = "%Y-%m-%d %H:%M:%S"; };
      };
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    defaultEditor = true;
  };
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
      r = "exec systemctl reboot";
      s = "exec systemctl poweroff";
      l = "exec i3-msg exit";
    };
    configFile.text = ''
      $env.config.buffer_editor = "nvim";
      $env.config.show_banner = false;
      $env.config.completions.external.enable = true
      $env.PATH = ($env.PATH | prepend "/nix/var/nix/profiles/default/bin" | prepend "/home/ofrades/.nix-profile/bin")
    '';
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
      "theme" = "catppuccin-frappe";
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
  programs.starship.enable = true;
  programs.starship.enableNushellIntegration = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableNushellIntegration = true;
  programs.home-manager.enable = true;
}
