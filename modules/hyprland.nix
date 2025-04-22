{ inputs, pkgs, ... }: {
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  home.packages = [
    pkgs.hyprpaper
    pkgs.hypridle
    pkgs.hyprshot
    pkgs.hyprlock
    pkgs.wofi

    pkgs.swww
    pkgs.dunst
    pkgs.libnotify
    pkgs.wl-clipboard
    pkgs.grimblast
    pkgs.xdg-desktop-portal-hyprland
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/dot/wallpaper.png
        wallpaper = ,${config.home.homeDirectory}/dot/wallpaper.png
      '';
    };
  };

  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" ];
          middle = [ "media" ];
          right = [ "volume" "systray" "notifications" ];
        };
      };
    };
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      general = {
        gaps_in = 10;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(bd93f9ee) rgba(6272a4ee) 45deg";
        "col.inactive_border" = "rgba(282a36aa)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      exec-once = [
        "hyprpaper"
        "dunst"
        "wl-clipboard-history -t"
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        "nm-applet --indicator"
        "hyprpaper --mode fill"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Key bindings
      bind = [
        "$mainMod, Return, exec, ghostty"
        "$mainMod SHIFT, q, killactive,"
        "$mainMod, d, exec, wofi --show drun"
        "$mainMod, f, fullscreen,"
        "$mainMod SHIFT, space, togglefloating,"
        "$mainMod, space, exec, wofi --show window"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod, b, splitratio, -0.05"
        "$mainMod, v, splitratio, +0.05"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, s, exec, grimblast copy area"
        ", Print, exec, grimblast copy output"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, c, exec, clipman pick --tool wofi"
        "$mainMod SHIFT, c, exec, hyprctl reload"
      ];

      env = [
        "LIBVA_DRIVER_NAME=nvidia"
        "XDG_SESSION_TYPE=wayland"
        "GBM_BACKEND=nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME=nvidia"
        "WLR_NO_HARDWARE_CURSORS=1"
      ];

      # Monitors
      monitor = [ ",preferred,auto,1" ];

      input = {
        kb_layout = "us,pt";
        kb_options = "grp:win_space_toggle,caps:escape";
        follow_mouse = 1;
        sensitivity = 0;
      };

      windowrulev2 = [ "opacity 0.9 0.9,class:^(ghostty)$" ];

      "$mainMod" = "SUPER";
    };
  };
  programs.wofi = {
    enable = true;
    settings = {
      location = "bottom-right";
      allow_markup = true;
      width = 250;
    };
  };
}
