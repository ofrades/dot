{ config, inputs, pkgs, ... }: {
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  # === PACKAGES ===
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprpaper
    hypridle
    hyprshot
    hyprlock
    hyprshade
    hyprcursor
    hyprpicker
    hyprsunset

    # Wayland utilities
    swww
    walker
    libnotify
    wl-clipboard
    cliphist
    wf-recorder
    brightnessctl
    grimblast
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    polkit_gnome
  ];

  # === CONFIG FILES ===
  home.file = {
    # Wallpaper configuration
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/dot/wall.jpg
        wallpaper = ,${config.home.homeDirectory}/dot/wall.jpg
      '';
    };
  };

  # === HYPRLAND CONFIGURATION ===
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # === VARIABLES ===
      "$mainMod" = "SUPER";

      # === ENVIRONMENT ===
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland,x11,*"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Adwaita"
        "HYPRCURSOR_SIZE,24"
        "GTK_USE_PORTAL,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,wayland"
      ];

      # === STARTUP APPLICATIONS ===
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "hyprpaper" # Wallpaper
        "wl-paste --watch cliphist store" # Clipboard history
        # "nm-applet --indicator"        # Removed to fix duplicate network icons
        "walker --gapplication-service" # App launcher
        "gnome-keyring-daemon --start" # Keyring
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "easyeffects --gapplication-service" # Audio effects
        "hyprpanel" # Status bar
        "hypridle" # Screen lock/sleep
        "hyprlock" # Lock screen
      ];

      # === WINDOW MANAGEMENT ===
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = { new_status = "master"; };

      # === APPEARANCE ===
      general = {
        allow_tearing = true;
        gaps_in = 10;
        gaps_out = 10;
        border_size = 3;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
        shadow = {
          enabled = true;
          ignore_window = true;
          offset = "2 2";
          range = 8;
          render_power = 2;
        };
      };

      # === ANIMATIONS ===
      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 1, overshot, slide"
          "windowsOut, 1, 1, smoothOut, slide"
          "windowsMove, 1, 1, default"
          "border, 1, 10, default"
          "fade, 1, 2, smoothIn"
          "workspaces, 1, 6, default"
          "fadeDim, 1, 2, smoothIn"
          "specialWorkspace, 1, 4, default, slidevert"
        ];
      };

      # === INPUT CONFIGURATION ===
      input = {
        kb_layout = "us,pt";
        kb_options = "grp:win_space_toggle,caps:escape";
        follow_mouse = 2;
        sensitivity = 0.5;
        repeat_rate = 25;
        repeat_delay = 200;
      };

      # === MONITORS ===
      monitor = [ ",preferred,auto,1" ];

      # === MISCELLANEOUS ===
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
      };

      # === WINDOW RULES ===
      windowrulev2 = [ "opacity 0.9 0.9,class:^(ghostty)$" ];

      # === MOUSE BINDINGS ===
      bindm = [
        "$mainMod, mouse:272, movewindow" # Move windows with mouse
        "$mainMod, mouse:273, resizewindow" # Resize windows with mouse
      ];

      # === KEY BINDINGS ===
      bind = [
        # Terminal
        "$mainMod, Return, exec, ghostty"

        # Window Management
        "$mainMod SHIFT, q, killactive,"
        "$mainMod, f, fullscreen,"
        "$mainMod SHIFT, space, togglefloating,"

        # Window Focus/Movement
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

        # Applications
        "$mainMod, d, exec, walker"
        "$mainMod, e, exec, walker -m emojis"
        "$mainMod, c, exec, walker -m clipboard"
        "$mainMod, b, exec, brave"

        # System Controls
        "alt, L, exec, hyprlock"
        "$mainMod SHIFT, s, exec, hyprshot -m region --freeze"
        "$mainMod SHIFT, c, exec, hyprctl reload"

        # Workspaces
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

        # Move Window to Workspace
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

        # Media Controls
        ", Print, exec, grimblast copy output"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [{
        path = "~/Pictures/wall.jpg";
        blur_passes = 3;
        blur_size = 8;
      }];

      input-field = [{
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        outline_thickness = 5;
        placeholder_text = "Matrix control center password...";
        shadow_passes = 2;
        rounding = 0;
      }];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Panel configuration
  programs.hyprpanel = {
    enable = true;
    overwrite.enable = true;
    overlay.enable = true;

    settings = {
      theme = {
        name = "tokyo_night";
        font.size = "1rem";
      };
      layout = {
        "bar.layouts" = {
          "*" = {
            "left" = [ "dashboard" "workspaces" "windowtitle" ];
            "middle" = [ "clock" "microphone" "cava" ];
            "right" = [
              "systray"
              "hyprsunset"
              "hypridle"
              "volume"
              "network"
              "netstat"
              "power"
              "notifications"
            ];
          };
        };
      };
      bar = {
        workspaces = { show_icons = true; };
        customModules.cava = {
          showIcon = false;
          stereo = true;
        };
      };
    };

    override = {
      "bar.clock.format" = "%b %d %H:%M";
      "menus.clock.time.military" = true;
      "menus.clock.weather.location" = "Viseu";
      "menus.clock.weather.unit" = "metric";
      "bar.notifications.hideCountWhenZero" = true;
      "bar.volume.label" = false;
      "bar.network.label" = true;
      "bar.media.show_active_only" = true;
      "bar.launcher.autoDetectIcon" = true;
      "notifications.position" = "top right";
    };
  };
}
