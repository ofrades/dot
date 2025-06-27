{
  config,
  pkgs,
  ...
}:
{

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
    hyprpanel

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

  programs.kitty.enable = true;

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
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      # === VARIABLES ===
      "$mainMod" = "SUPER";

      # === ENVIRONMENT ===
      # env = [
      #   "LIBVA_DRIVER_NAME,nvidia"
      #   "CLUTTER_BACKEND,wayland"
      #   "GDK_BACKEND,wayland,x11,*"
      #   "XDG_SESSION_TYPE,wayland"
      #   "XDG_CURRENT_DESKTOP,Hyprland"
      #   "XDG_SESSION_DESKTOP,Hyprland"
      #   "GBM_BACKEND,nvidia-drm"
      #   "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      #   "GTK_USE_PORTAL,1"
      #   "QT_QPA_PLATFORM,wayland;xcb"
      #   "QT_QPA_PLATFORMTHEME,gtk2"
      #   "QT_SCREEN_SCALE_FACTORS,1"
      #   "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      #   "SDL_VIDEODRIVER,wayland"
      # ];

      # === STARTUP APPLICATIONS ===
      exec = [
        "gsettings set org.gnome.desktop.interface gtk-theme Yaru"
        "gsettings set org.gnome.desktop.interface cursor-theme Adwaita"
        "gsettings set org.gnome.desktop.interface icon-theme Papirus"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
        "gsettings set org.gnome.desktop.interface text-scaling-factor 1"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
        "hyprpanel" # Status bar
        "hyprpaper" # Wallpaper
        "hypridle" # Screen lock/sleep
        "wl-clip-persist --clipboard regular"
        "wl-paste --watch cliphist store" # Clipboard history
        "walker --gapplication-service" # App launcher
      ];

      # === WINDOW MANAGEMENT ===
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # === APPEARANCE ===
      general = {
        allow_tearing = true;
        gaps_in = 10;
        gaps_out = 10;
        border_size = 3;
        layout = "dwindle";
        "col.active_border" = "rgba(1ABC9Cbb) rgba(DAA856ee)";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
        shadow.enabled = false;
      };

      # === ANIMATIONS ===
      animations.enabled = false;

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
        "$mainMod, mouse:272, movewindow" # Move windows with mouse
        "$mainMod, mouse:273, resizewindow" # Resize windows with mouse
      ];

      # === KEY BINDINGS ===
      bind = [
        # Terminal
        "$mainMod, t, exec, ghostty"

        # Window Management
        "$mainMod, q, killactive,"
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

        # Applications
        "$mainMod, d, exec, walker"
        "$mainMod, e, exec, walker -m emojis"
        "$mainMod, c, exec, walker -m clipboard"
        "$mainMod, b, exec, brave"

        # System Controls
        "alt, l, exec, hyprlock"
        "$mainMod, p, exec, flameshot gui"
        "$mainMod SHIFT, r, exec, hyprctl reload"

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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          path = "${config.home.homeDirectory}/dot/wallpaper_day.png";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [
        {
          text = "Hi there, $USER";
          color = "rgb(255, 255, 255)";
          font_size = 24;
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 5;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
          rounding = 10;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
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

  # Panel configuration
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme = {
        name = "tokyo_night";
        font.size = "0.8rem";
        bar.opacity = 50;
      };
      layout = {
        "bar.layouts" = {
          "*" = {
            "left" = [
              "dashboard"
              "workspaces"
              "windowtitle"
            ];
            "middle" = [
              "clock"
              "microphone"
              "cava"
            ];
            "right" = [
              "systray"
              "hyprsunset"
              "hypridle"
              "volume"
              "network"
              "netstat"
              "kbinput"
              "power"
              "notifications"
            ];
          };
        };
      };
      bar = {
        workspaces = {
          show_icons = true;
        };
        customModules.cava = {
          showIcon = false;
          stereo = true;
        };
      };
    };

  };

}
