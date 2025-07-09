{ config, pkgs, ... }: {

  # === PACKAGES ===
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprpaper
    hypridle
    hyprshot
    hyprlock
    hyprshade
    hyprpicker
    hyprsunset

    # Wayland utilities
    walker
    wl-clipboard
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    grimblast
    xdg-desktop-portal-hyprland
  ];

  # === CONFIG FILES ===
  home.file = {
    # Wallpaper configuration
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/dot/wallpaper_day.png
        wallpaper = ,${config.home.homeDirectory}/dot/wallpaper_day.png
      '';
    };
  };

  programs = {
    kitty.enable = true;

    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          ignore_empty_input = true;
        };

        background = [{
          path = "${config.home.homeDirectory}/dot/wallpaper_day.png";
          blur_passes = 3;
          blur_size = 8;
        }];

        label = [{
          text = "Hi there, $USER";
          color = "rgb(255, 255, 255)";
          font_size = 24;
          position = "0, -40";
          halign = "center";
          valign = "center";
        }];

        input-field = [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 5;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
          rounding = 10;
        }];
      };
    };

    hyprpanel = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          name = "tokyo_night";
          font.size = "0.7rem";
        };
        bar.launcher.autoDetectIcon = true;

        bar.layouts = {
          "*" = {
            "left" = [ "dashboard" "clock" "workspaces" "windowtitle" ];
            "middle" = [ "volume" ];
            "right" = [
              "systray"
              "hyprsunset"
              "hypridle"
              "ram"
              "cpu"
              "cputemp"
              "storage"
              "network"
              "netstat"
              "weather"
              "kbinput"
              "notifications"
              "power"
            ];
          };
        };
      };
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # === HYPRLAND CONFIGURATION ===
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;

    settings = {
      # === VARIABLES ===
      "$mainMod" = "SUPER";
      "$browser" = "brave";
      "$webapp" = "$browser --app";
      "$terminal" = "ghostty";

      # === ENVIRONMENT ===
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland,x11,*"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,gtk2"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,wayland"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
        "sleep 1 && hyprpaper"
        "sleep 3 && hypridle"
        "wl-clip-persist --clipboard regular"
        "wl-paste --watch cliphist store"
        "walker --gapplication-service"
      ];

      # === WINDOW MANAGEMENT ===
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # === APPEARANCE ===
      general = {
        allow_tearing = true;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        "col.active_border" = "rgba(1ABC9Cbb) rgba(DAA856ee)";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # === ANIMATIONS ===
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # === INPUT CONFIGURATION ===
      input = {
        kb_layout = "us,pt";
        kb_options = "grp:win_space_toggle,caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_rate = 25;
        repeat_delay = 200;
      };

      # === MONITORS ===
      monitor = [ ",preferred,auto,1" ];

      # === WINDOW RULES ===
      windowrulev2 = [
        "opacity 0.9 0.9,class:^(ghostty)$"
        "float,class:^(org.gnome.Nautilus)$"
        "float,class:^(gnome-control-center)$"
        "float,class:^(gnome-disks)$"
        "float,class:^(gnome-system-monitor)$"
        "float,class:^(org.gnome.Calculator)$"
        "float,class:^(org.gnome.Calendar)$"
        "float,class:^(org.gnome.font-viewer)$"
        "float,class:^(file-roller)$"
        "float,class:^(eog)$"
        "float,class:^(simple-scan)$"
        "float,title:^(Picture-in-Picture)$"
        "float,title:^(Save As)$"
        "float,title:^(Open File)$"
      ];

      # === MOUSE BINDINGS ===
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # === KEY BINDINGS ===
      bind = [
        "$mainMod, t, exec, ghostty"

        # Window Management
        "$mainMod, q, killactive"
        "$mainMod SHIFT, q, exec, hyprpanel t powerdropdownmenu"

        "$mainMod, f, fullscreen"
        "$mainMod SHIFT, space, togglefloating"

        # Window Focus/Movement
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Applications
        "$mainMod, d, exec, walker"
        "$mainMod, e, exec, walker -m emojis"
        "$mainMod, c, exec, walker -m clipboard"
        "$mainMod, b, exec, $browser"

        # Fixed webapp bindings - use the full command directly
        "$mainMod, a, exec, brave --app=https://chatgpt.com"
        "$mainMod SHIFT, a, exec, brave --app=https://grok.com"
        "$mainMod SHIFT, c, exec, brave --app=https://claude.com"
        "$mainMod, y, exec, brave --app=https://youtube.com"

        # System Controls
        "$mainMod, ESCAPE, exec, hyprlock"
        ", PRINT, exec, hyprshot -m region"
        "SHIFT, PRINT, exec, hyprshot -m window"
        "CTRL, PRINT, exec, hyprshot -m output"
        "$mainMod, PRINT, exec, hyprpicker -a"
        "$mainMod SHIFT, r, exec, hyprctl reload"

        # Debug bindings
        "$mainMod SHIFT, t, exec, notify-send 'Test' 'Keybinding works'"

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
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 420;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
