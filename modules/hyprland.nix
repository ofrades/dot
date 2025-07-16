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
    wl-clipboard
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    grimblast
    xdg-desktop-portal-hyprland
    
    # Additional clipboard helpers
    xclip
    xsel
    
    # System utilities
    brightnessctl
    networkmanagerapplet
    blueman
    
    # Notifications
    dunst
    libnotify
  ];

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          ignore_empty_input = true;
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

  # Using a neutral GTK theme that complements the sepia tones
  gtk = {
    enable = true;
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
        # Fix clipboard sharing between Wayland and X11
        "GDK_SCALE,1"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"
        # Enhanced clipboard persistence
        "wl-clip-persist --clipboard both"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        # System services
        "nm-applet --indicator"
        "blueman-applet"
        "dunst"
        # Hyprland components
        "sleep 1 && hyprpaper"
        "sleep 3 && hypridle"
        "sleep 1 && waybar"
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

      # === GESTURES ===
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 300;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = true;
      };

      # === MISCELLANEOUS ===
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vrr = 1;
        enable_swallow = true;
        swallow_regex = "^(ghostty)$";
        focus_on_activate = true;
      };
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
        # Application shortcuts
        "$mainMod, t, exec, ghostty"
        "$mainMod, q, killactive"
        "$mainMod SHIFT, q, exec, wofi-power-menu"
        "$mainMod, f, fullscreen"
        "$mainMod SHIFT, space, togglefloating"
        "$mainMod, p, pseudo"
        "$mainMod, s, togglesplit"
        
        # Focus movement
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        
        # Window movement
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        
        # Resize windows
        "$mainMod CTRL, h, resizeactive, -20 0"
        "$mainMod CTRL, l, resizeactive, 20 0"
        "$mainMod CTRL, k, resizeactive, 0 -20"
        "$mainMod CTRL, j, resizeactive, 0 20"
        
        # Launchers and utilities
        "$mainMod, d, exec, pkill wofi || wofi --show drun -O alphabetical"
        "$mainMod, e, exec, bemoji -t"
        "$mainMod, c, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod, b, exec, $browser"
        "$mainMod, a, exec, brave --app=https://chatgpt.com"
        "$mainMod SHIFT, a, exec, brave --app=https://grok.com"
        "$mainMod SHIFT, c, exec, brave --app=https://claude.com"
        "$mainMod, y, exec, brave --app=https://youtube.com"
        "$mainMod, ESCAPE, exec, hyprlock"
        
        # Screenshots
        ", PRINT, exec, hyprshot -m region"
        "SHIFT, PRINT, exec, hyprshot -m window"
        "CTRL, PRINT, exec, hyprshot -m output"
        "$mainMod, PRINT, exec, hyprpicker -a"
        
        # Media controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        
        # Brightness controls
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        
        # System controls
        "$mainMod SHIFT, r, exec, hyprctl reload"
        "$mainMod SHIFT, t, exec, notify-send 'Test' 'Keybinding works'"
        
        # Workspace switching
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
        
        # Move to workspace
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
        
        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
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
