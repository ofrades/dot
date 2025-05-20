{ config, inputs, pkgs, ... }: {

  # Package list with polybar already included
  home.packages = with pkgs; [
    i3status
    i3lock
    autotiling
    networkmanagerapplet
    feh
    picom
    tokyonight-gtk-theme
    papirus-icon-theme
    polybar
    xkblayout-state
    xclip
    (writeScriptBin "rofi-power" ''
      #!${pkgs.bash}/bin/bash
      OPTIONS="Lock\nLogout\nReboot\nShutdown\nSuspend"
      LAUNCHER="rofi -dmenu -i -p Power"
      POWER=$(echo -e $OPTIONS | $LAUNCHER | awk '{print $1}')
      case $POWER in
        Logout)
          i3-msg exit
          ;;
        Suspend)
          systemctl suspend
          ;;
        Reboot)
          systemctl reboot
          ;;
        Shutdown)
          systemctl poweroff
          ;;
        Lock)
          i3lock -c 000000
          ;;
      esac
    '')
  ];
  services.picom = {
    enable = true;
    inactiveOpacity = 0.9;
    menuOpacity = 0.9;
    activeOpacity = 1;
    backend = "glx";
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraConfig = ''
        for_window [class="^.*"] border pixel 2
        client.focused          #bb9af7 #7aa2f7 #c0caf5
        client.unfocused        #333333 #222222 #888888
      '';
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        defaultWorkspace = "workspace number 1";
        menu = "rofi -show drun";
        fonts = {
          names = [ "JetBrains Mono" ];
          size = 9.0;
        };
        gaps = {
          inner = 10;
          outer = 0;
          smartGaps = false;
        };
        keybindings =
          let modifier = config.xsession.windowManager.i3.config.modifier;
          in {
            # Common commands
            "${modifier}+t" = "exec ghostty";
            "${modifier}+q" = "kill";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+Shift+space" = "floating toggle";

            # Application launchers
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+e" = "exec rofi -show emoji";
            "${modifier}+a" = "exec rofi -show filebrowser";
            "${modifier}+n" = "exec rofi-network-manager";
            "${modifier}+b" = "exec brave";

            # Fixed lock command - using a consistent approach
            "${modifier}+Escape" = "exec i3lock -c 000000";

            # Toggle mic
            "${modifier}+m" =
              "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            # Navigation
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            # Workspace management
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

            # System controls
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";
            "${modifier}+Shift+q" = "exec rofi-power";

            # Clipboard management
            "${modifier}+c" = "exec env CM_LAUNCHER=rofi clipmenu";

            # Screenshot tools
            "Print" = "exec gnome-screenshot";
            "${modifier}+p" = "exec flameshot gui";

            # Media controls
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
        # Disable the default i3 bar since we're using polybar
        bars = [ ];
        startup = [
          {
            command =
              "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            notification = false;
            always = true;
          }
          {
            command = "${pkgs.picom}/bin/picom --daemon";
            notification = false;
            always = true;
          }
          {
            command =
              "${pkgs.feh}/bin/feh --bg-fill ${config.home.homeDirectory}/dot/wallpaper_day.png";
            notification = false;
            always = true;
          }
          # Using xss-lock for automatic screen locking
          {
            command = "exec --no-startup-id xss-lock -- i3lock -c 000000";
            notification = false;
          }
          # Start polybar
          {
            command = "$HOME/.config/polybar/launch.sh";
            notification = false;
            always = true;
          }
          {
            command = "autotiling";
            notification = false;
            always = true;
          }
        ];
        window.commands = [
          # Grouped floating window rules for cleaner configuration
          {
            command = "floating enable";
            criteria = {
              window_role = "pop-up|bubble|task_dialog|Preferences";
              window_type = "dialog|menu";
            };
          }
        ];
      };
    };
  };

  gtk.enable = true;
  gtk.theme.package = pkgs.tokyonight-gtk-theme;
  gtk.theme.name = "tokyonight-gtk-theme";

  gtk.iconTheme.package = pkgs.papirus-icon-theme;
  gtk.iconTheme.name = "Papirus-Dark";

  services.polybar = {
    enable = true;
    package = pkgs.polybar;
    script = ''
      #!/bin/sh
      polybar main &
    '';
    settings = {
      "colors" = {
        background = "#1a1b26";
        background-alt = "#24283b";
        foreground = "#c0caf5";
        primary = "#7aa2f7";
        secondary = "#bb9af7";
        alert = "#f7768e";
        disabled = "#565f89";
      };

      "bar/main" = {
        width = "100%";
        height = "24pt";
        radius = 0;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = "3pt";

        border-size = 0;
        border-color = "#00000000";

        padding-left = 0;
        padding-right = 1;

        module-margin = 1;

        separator = "|";
        separator-foreground = "\${colors.disabled}";

        font-0 = "JetBrains Mono:size=8;2";

        modules-left = "xworkspaces xwindow";
        modules-center = "date wireplumber microphone";
        modules-right = "memory cpu eth keyboard";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = true;
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline = "\${colors.primary}";
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/wireplumber" = {
        type = "custom/script";
        exec = ''
          ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SINK@ | ${pkgs.gawk}/bin/awk '{printf "%d%%", $2 * 100; if ($3 == "[MUTED]") print " MUTED"; else print ""}'
        '';
        interval = 1;
        format-prefix = "VOL ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%output%";
        click-left =
          "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
        click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        scroll-up =
          "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+";
        scroll-down =
          "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-";
      };
      "module/microphone" = {
        type = "custom/script";
        exec = ''
          ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | ${pkgs.gawk}/bin/awk '{printf "%d%%", $2 * 100; if ($3 == "[MUTED]") print " MUTED"; else print ""}'
        '';
        interval = 1;
        format-prefix = "MIC ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%output%";
        click-left =
          "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        scroll-up =
          "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
        scroll-down =
          "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };

      "module/eth" = {
        type = "internal/network";
        interface-type = "wired";
        interval = 3;

        format-connected-prefix = "NET ";
        format-connected-prefix-foreground = "\${colors.primary}";
        label-connected = "%local_ip%";

        format-disconnected = "";
      };

      "module/keyboard" = {
        type = "custom/script";
        exec = "${pkgs.xkblayout-state}/bin/xkblayout-state print '%s'";
        interval = 1;
        label = "%output%";
        label-foreground = "\${colors.primary}";
        click-left = "setxkbmap us";
        click-right = "setxkbmap pt";
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;

        date = "%Y-%m-%d %H:%M";

        label = "%date%";
        label-foreground = "\${colors.primary}";
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
  };

  # Create polybar launch script
  home.file.".config/polybar/launch.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      # Terminate already running bar instances
      killall -q polybar

      # Wait until the processes have been shut down
      while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

      # Launch Polybar
      polybar main &

      echo "Polybar launched..."
    '';
  };

  # Remaining program configurations
  services.clipmenu = {
    enable = true;
    launcher = "${pkgs.rofi}/bin/rofi";
  };
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
      rofi-file-browser
      rofi-network-manager
    ];
    extraConfig = {
      modi = "combi,calc";
      combi-modi =
        "drun,run,window,file-browser,ssh,keys,emoji,network-manager";
    };
    terminal = "ghostty";
    location = "center";
  };
}
