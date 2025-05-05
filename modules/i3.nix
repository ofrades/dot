{ config, inputs, pkgs, ... }: {

  home.packages = with pkgs; [
    i3-gaps
    i3status
    i3lock
    networkmanagerapplet
    feh
    picom
    xclip
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
            "${modifier}+t" = "exec ghostty";
            "${modifier}+q" = "kill";
            "${modifier}+d" = "exec rofi -show drun";
            "${modifier}+e" = "exec rofi -show emoji";
            "${modifier}+c" = "exec env CM_LAUNCHER=rofi clipmenu";
            "${modifier}+x" =
              "exec rofi -modi rofi-power-menu -show rofi-power-menu";
            "${modifier}+b" = "exec brave";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "Alt+l" = "exec i3lock --ignore-empty-password";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+Shift+space" = "floating toggle";
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
            "${modifier}+p" = "exec flameshot gui";
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
            command = "clipmenud";
            notification = false;
          }
          {
            command = "easyeffects --gapplication-service";
            notification = false;
          }
          {
            command =
              "${pkgs.feh}/bin/feh --bg-fill ${config.home.homeDirectory}/dot/wallpaper_day.png";
            notification = false;
            always = true;
          }
          {
            command = "exec --no-startup-id xss-lock -- i3lock -c 000000";
            notification = true;
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
        settings = { format = "%Y-%m-%d %H:%M"; };
      };
    };
  };
  services.clipmenu.enable = true;
  programs.rofi = {
    enable = true;
    theme = "gruvbox-dark-hard";
    plugins = with pkgs; [
      networkmanager_dmenu
      rofi-top
      rofi-calc
      rofi-emoji
      rofi-systemd
      rofi-menugen
      rofi-bluetooth
      rofi-power-menu
      rofi-pulse-select
      rofi-file-browser
    ];
    terminal = "ghostty";
    location = "center";
  };
}
