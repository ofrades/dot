{ config, pkgs, ... }: {
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

    # Add i3-related packages
    i3
    i3status
    i3lock
    brightnessctl
    gnome-flashback # For GNOME integration
    polkit_gnome # For authentication dialogs
  ];

  home.file = {
    ".config/nvim".source = ../../nvim/.config/nvim;

    # Create the gnome-i3 session file
    ".local/share/xsessions/gnome-i3.desktop".text = ''
      [Desktop Entry]
      Name=GNOME + i3
      Comment=GNOME with i3 as window manager
      Exec=${pkgs.bash}/bin/bash ${config.home.homeDirectory}/.local/bin/gnome-session-i3
      Type=Application
    '';

    # Create the gnome-session-i3 script
    ".local/bin/gnome-session-i3" = {
      text = ''
        #!/bin/bash
        export XDG_CURRENT_DESKTOP=GNOME-i3
        export GNOME_SHELL_SESSION_MODE=ubuntu
        exec gnome-session --session=ubuntu-i3 "$@"
      '';
      executable = true;
    };

    # Create the session configuration file
    ".local/share/gnome-session/sessions/ubuntu-i3.session".text = ''
      [GNOME Session]
      Name=Ubuntu-i3
      RequiredComponents=org.gnome.SettingsDaemon.A11ySettings;org.gnome.SettingsDaemon.Color;org.gnome.SettingsDaemon.Datetime;org.gnome.SettingsDaemon.Housekeeping;org.gnome.SettingsDaemon.Keyboard;org.gnome.SettingsDaemon.MediaKeys;org.gnome.SettingsDaemon.Power;org.gnome.SettingsDaemon.PrintNotifications;org.gnome.SettingsDaemon.Rfkill;org.gnome.SettingsDaemon.ScreensaverProxy;org.gnome.SettingsDaemon.Sharing;org.gnome.SettingsDaemon.Smartcard;org.gnome.SettingsDaemon.Sound;org.gnome.SettingsDaemon.Wacom;org.gnome.SettingsDaemon.XSettings;i3-gnome
    '';

    # Create theme switching script
    ".local/bin/toggle-theme" = {
      text = ''
        #!/bin/bash

        # Check current theme
        current_theme=$(gsettings get org.gnome.desktop.interface color-scheme)

        # Toggle between dark and light
        if [[ $current_theme == *"prefer-dark"* ]]; then
          # Switch to light theme
          gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
          gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
          # Update your terminal theme if applicable (for ghostty)
          if [ -f ~/.config/ghostty/config ]; then
            sed -i 's/^theme = dark:.*/theme = light:catppuccin-latte/' ~/.config/ghostty/config
          fi
          # Notify user
          notify-send "Theme Switched" "Light theme activated"
        else
          # Switch to dark theme
          gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
          gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
          # Update your terminal theme if applicable (for ghostty)
          if [ -f ~/.config/ghostty/config ]; then
            sed -i 's/^theme = light:.*/theme = dark:catppuccin-frappe/' ~/.config/ghostty/config
          fi
          # Notify user
          notify-send "Theme Switched" "Dark theme activated"
        fi

        # Restart i3 to apply changes to bar (optional, remove if it causes issues)
        i3-msg restart
      '';
      executable = true;
    };
  };

  # Configure i3
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    config = {
      modifier = "Mod4";
      terminal = "ghostty";
      menu = "rofi -show drun";
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 10.0;
      };
      gaps = {
        inner = 5;
        outer = 0;
        smartGaps = true;
      };
      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in {
          "${modifier}+Return" = "exec ghostty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec rofi -show drun";

          # Theme toggle hotkey (Mod+Shift+t)
          "${modifier}+Shift+t" =
            "exec ${config.home.homeDirectory}/.local/bin/toggle-theme";

          # Focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Split
          "${modifier}+b" = "split h";
          "${modifier}+v" = "split v";

          # Fullscreen
          "${modifier}+f" = "fullscreen toggle";

          # Layout
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Floating
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          # Focus parent
          "${modifier}+a" = "focus parent";

          # Workspaces
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

          # Move to workspace
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

          # Reload/Restart
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" =
            "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";

          # Screenshot (GNOME)
          "Print" = "exec gnome-screenshot";
          "${modifier}+Print" = "exec gnome-screenshot -a";

          # Volume controls
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" =
            "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";

          # Brightness controls
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
          "XF86MonBrightnessDown" =
            "exec --no-startup-id brightnessctl set 5%-";

          # Resize mode
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
        statusCommand = "i3status";
        colors = {
          # These colors work well with both light/dark themes
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
        # Start GNOME services
        {
          command = "/usr/lib/gnome-settings-daemon/gsd-xsettings";
          notification = false;
        }
        {
          command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
          notification = false;
        }
        {
          command = "gnome-flashback";
          notification = false;
        }
        {
          command = "nm-applet";
          notification = false;
        }
        # Set dark theme by default at startup (comment this line if you prefer light theme by default)
        {
          command =
            "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'";
          notification = false;
        }
        {
          command =
            "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'";
          notification = false;
        }
      ];
      window.commands = [
        # Make specific GNOME apps floating by default
        {
          command = "floating enable";
          criteria = { class = "Gnome-control-center"; };
        }
        {
          command = "floating enable";
          criteria = { class = "Gnome-settings-daemon"; };
        }
        {
          command = "floating enable";
          criteria = { class = "Nautilus"; };
        }
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

  # Configure i3status
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
