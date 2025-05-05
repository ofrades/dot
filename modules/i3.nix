{ config, inputs, pkgs, ... }: {

  # Simplified package list - removed redundant i3-gaps package since it's specified in the xsession
  home.packages = with pkgs; [
    i3status
    i3lock
    networkmanagerapplet
    feh
    picom
    clipmenu
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

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraConfig = ''
        default_border pixel 1
      '';
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
            # Common commands
            "${modifier}+t" = "exec ghostty";
            "${modifier}+q" = "kill";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+Shift+space" = "floating toggle";

            # Application launchers
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+e" = "exec rofi -show emoji";
            "${modifier}+b" = "exec brave";

            # Fixed lock command - using a consistent approach
            "${modifier}+Escape" = "exec i3lock -c 000000";

            # Navigation
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+a" = "focus parent";

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
            "${modifier}+Shift+e" =
              "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";
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
        bars = [{
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }];
        startup = [
          {
            command =
              "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            notification = false;
            always = false;
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
            command = "${pkgs.clipmenu}/bin/clipmenud";
            notification = false;
            always = false;
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

  # i3status configuration
  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      interval = 5;
    };
    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  # Remaining program configurations
  services.clipmenu = {
    enable = true;
    launcher = "${pkgs.rofi}/bin/rofi";
  };
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    plugins = with pkgs; [ rofi-emoji rofi-calc rofi-bluetooth ];
    terminal = "ghostty";
    location = "center";
  };
}
