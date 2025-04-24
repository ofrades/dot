{ config, inputs, pkgs, ... }: {
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
  home.packages = [
    pkgs.hyprpaper
    pkgs.hypridle
    pkgs.hyprshot
    pkgs.hyprlock
    pkgs.hyprshade
    pkgs.hyprcursor
    pkgs.hyprpicker
    pkgs.hyprsunset
    pkgs.hyprpanel

    pkgs.swww
    pkgs.walker
    pkgs.libnotify
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.wf-recorder
    pkgs.brightnessctl
    pkgs.grimblast
    pkgs.xdg-desktop-portal-hyprland
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/dot/wall.png
        wallpaper = ,${config.home.homeDirectory}/dot/wall.png
      '';
    };
    ".config/hypr/hyprlock.conf" = {
      text = ''
        # BACKGROUND
        background {
            monitor =
            path = ~/Pictures/wall.png
            blur_passes = 3
            contrast = 0.8916
            brightness = 0.8172
            vibrancy = 0.1696
            vibrancy_darkness = 0.0
        }

        # GENERAL
        general {
            # no_fade_in = false
            grace = 5
            # disable_loading_bar = true
        }

        # INPUT FIELD
        input-field {
            monitor =
            size = 280, 80
            outline_thickness = 2
            dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true
            outer_color = rgba(0, 0, 0, 0)
            inner_color = rgba(0, 0, 0, 0.5)
            font_color = rgb(200, 200, 200)
            fade_on_empty = false
            placeholder_text = <i><span foreground="##cdd6f4">Password...</span></i>
            hide_input = false
            position = 0, -120
            halign = center
            valign = center
        }

        # TIME
        label {
            monitor =
            text = cmd[update:1000] echo "$(date +"%-H:%M")"
            font_size = 120
            font_family = Maple Mono Bold
            position = 0, -300
            halign = center
            valign = top
        }

        # USER
        label {
            monitor =
            text = Olá $USER
            font_size = 25
            font_family = Maple Mono
            position = 0, -40
            halign = center
            valign = center
        }
      '';
    };

    ".config/hypr/hypridle.conf" = {
      text = ''
        general {
            lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
            before_sleep_cmd = loginctl lock-session    # lock before suspend.
            after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
        }

        listener {
            timeout = 150                                # 2.5min.
            on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = brightnessctl -r                 # monitor backlight restore.
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        listener { 
            timeout = 150                                          # 2.5min.
            on-timeout = brightnessctl -sd dell::kbd_backlight set 0 # turn off keyboard backlight.
            on-resume = brightnessctl -rd dell::kbd_backlight        # turn on keyboard backlight.
        }

        listener {
            timeout = 300                                 # 5min
            on-timeout = loginctl lock-session            # lock screen when timeout has passed
        }

        listener {
            timeout = 330                                 # 5.5min
            on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
            on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
        }

        listener {
            timeout = 1800                                # 30min
            on-timeout = systemctl suspend                # suspend pc
        }
      '';
    };
    ".config/hyprpanel/config.json" = {
      text = ''
        {
          "bar.customModules.updates.pollingInterval": 1440000,
          "theme.font.size": "1rem",
          "theme.font.weight": 400,
          "bar.workspaces.show_numbered": false,
          "bar.workspaces.monitorSpecific": false,
          "theme.bar.menus.background": "#1a1b26",
          "theme.bar.background": "#1e2030",
          "theme.bar.buttons.media.icon": "#bb9af7",
          "theme.bar.buttons.media.text": "#bb9af7",
          "theme.bar.buttons.icon": "#ffffff",
          "theme.bar.buttons.text": "#ffffff",
          "theme.bar.buttons.hover": "#414868",
          "theme.bar.buttons.background": "#ffffff",
          "theme.bar.menus.text": "#c0caf5",
          "theme.bar.menus.border.color": "#414868",
          "theme.bar.buttons.media.background": "#ffffff",
          "theme.bar.menus.menu.volume.text": "#c0caf5",
          "theme.bar.menus.menu.volume.card.color": "#24283b",
          "theme.bar.menus.menu.volume.label.color": "#f7768e",
          "theme.bar.menus.popover.text": "#bb9af7",
          "theme.bar.menus.popover.background": "#1a1b26",
          "theme.bar.menus.menu.dashboard.powermenu.shutdown": "#f7768e",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.deny": "#f7768e",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.confirm": "#9ece6a",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.button_text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.body": "#c0caf5",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.label": "#bb9af7",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.border": "#414868",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.background": "#1a1b26",
          "theme.bar.menus.menu.dashboard.powermenu.confirmation.card": "#24283b",
          "theme.bar.menus.menu.notifications.switch.puck": "#565f89",
          "theme.bar.menus.menu.notifications.switch.disabled": "#565f89",
          "theme.bar.menus.menu.notifications.switch.enabled": "#bb9af7",
          "theme.bar.menus.menu.notifications.clear": "#f7768e",
          "theme.bar.menus.menu.notifications.switch_divider": "#414868",
          "theme.bar.menus.menu.notifications.border": "#414868",
          "theme.bar.menus.menu.notifications.card": "#24283b",
          "theme.bar.menus.menu.notifications.background": "#1a1b26",
          "theme.bar.menus.menu.notifications.no_notifications_label": "#414868",
          "theme.bar.menus.menu.notifications.label": "#bb9af7",
          "theme.bar.menus.menu.dashboard.monitors.disk.label": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.disk.bar": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.disk.icon": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.gpu.label": "#9ece6a",
          "theme.bar.menus.menu.dashboard.monitors.gpu.bar": "#9ece6a",
          "theme.bar.menus.menu.dashboard.monitors.gpu.icon": "#9ece6a",
          "theme.bar.menus.menu.dashboard.monitors.ram.label": "#e0af68",
          "theme.bar.menus.menu.dashboard.monitors.ram.bar": "#e0af68",
          "theme.bar.menus.menu.dashboard.monitors.ram.icon": "#e0af68",
          "theme.bar.menus.menu.dashboard.monitors.cpu.label": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.cpu.bar": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.cpu.icon": "#f7768e",
          "theme.bar.menus.menu.dashboard.monitors.bar_background": "#414868",
          "theme.bar.menus.menu.dashboard.directories.right.bottom.color": "#bb9af7",
          "theme.bar.menus.menu.dashboard.directories.right.middle.color": "#bb9af7",
          "theme.bar.menus.menu.dashboard.directories.right.top.color": "#73daca",
          "theme.bar.menus.menu.dashboard.directories.left.bottom.color": "#f7768e",
          "theme.bar.menus.menu.dashboard.directories.left.middle.color": "#e0af68",
          "theme.bar.menus.menu.dashboard.directories.left.top.color": "#f7768e",
          "theme.bar.menus.menu.dashboard.controls.input.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.controls.input.background": "#f7768e",
          "theme.bar.menus.menu.dashboard.controls.volume.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.controls.volume.background": "#f7768e",
          "theme.bar.menus.menu.dashboard.controls.notifications.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.controls.notifications.background": "#e0af68",
          "theme.bar.menus.menu.dashboard.controls.bluetooth.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.controls.bluetooth.background": "#7dcfff",
          "theme.bar.menus.menu.dashboard.controls.wifi.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.controls.wifi.background": "#bb9af7",
          "theme.bar.menus.menu.dashboard.controls.disabled": "#414868",
          "theme.bar.menus.menu.dashboard.shortcuts.recording": "#9ece6a",
          "theme.bar.menus.menu.dashboard.shortcuts.text": "#1a1b26",
          "theme.bar.menus.menu.dashboard.shortcuts.background": "#bb9af7",
          "theme.bar.menus.menu.dashboard.powermenu.sleep": "#7dcfff",
          "theme.bar.menus.menu.dashboard.powermenu.logout": "#9ece6a",
          "theme.bar.menus.menu.dashboard.powermenu.restart": "#e0af68",
          "theme.bar.menus.menu.dashboard.profile.name": "#f7768e",
          "theme.bar.menus.menu.dashboard.border.color": "#414868",
          "theme.bar.menus.menu.dashboard.background.color": "#1a1b26",
          "theme.bar.menus.menu.dashboard.card.color": "#24283b",
          "theme.bar.menus.menu.clock.weather.hourly.temperature": "#f7768e",
          "theme.bar.menus.menu.clock.weather.hourly.icon": "#f7768e",
          "theme.bar.menus.menu.clock.weather.hourly.time": "#f7768e",
          "theme.bar.menus.menu.clock.weather.thermometer.extremelycold": "#7dcfff",
          "theme.bar.menus.menu.clock.weather.thermometer.cold": "#7aa2f7",
          "theme.bar.menus.menu.clock.weather.thermometer.moderate": "#bb9af7",
          "theme.bar.menus.menu.clock.weather.thermometer.hot": "#e0af68",
          "theme.bar.menus.menu.clock.weather.thermometer.extremelyhot": "#f7768e",
          "theme.bar.menus.menu.clock.weather.stats": "#f7768e",
          "theme.bar.menus.menu.clock.weather.status": "#73daca",
          "theme.bar.menus.menu.clock.weather.temperature": "#c0caf5",
          "theme.bar.menus.menu.clock.weather.icon": "#f7768e",
          "theme.bar.menus.menu.clock.calendar.contextdays": "#414868",
          "theme.bar.menus.menu.clock.calendar.days": "#c0caf5",
          "theme.bar.menus.menu.clock.calendar.currentday": "#f7768e",
          "theme.bar.menus.menu.clock.calendar.paginator": "#f7768e",
          "theme.bar.menus.menu.clock.calendar.weekdays": "#f7768e",
          "theme.bar.menus.menu.clock.calendar.yearmonth": "#73daca",
          "theme.bar.menus.menu.clock.time.timeperiod": "#73daca",
          "theme.bar.menus.menu.clock.time.time": "#f7768e",
          "theme.bar.menus.menu.clock.text": "#c0caf5",
          "theme.bar.menus.menu.clock.border.color": "#414868",
          "theme.bar.menus.menu.clock.background.color": "#1a1b26",
          "theme.bar.menus.menu.clock.card.color": "#24283b",
          "theme.bar.menus.menu.battery.slider.puck": "#565f89",
          "theme.bar.menus.menu.battery.slider.backgroundhover": "#414868",
          "theme.bar.menus.menu.battery.slider.background": "#565f89",
          "theme.bar.menus.menu.battery.slider.primary": "#e0af68",
          "theme.bar.menus.menu.battery.icons.active": "#e0af68",
          "theme.bar.menus.menu.battery.icons.passive": "#565f89",
          "theme.bar.menus.menu.battery.listitems.active": "#e0af68",
          "theme.bar.menus.menu.battery.listitems.passive": "#c0caf5",
          "theme.bar.menus.menu.battery.text": "#c0caf5",
          "theme.bar.menus.menu.battery.label.color": "#e0af68",
          "theme.bar.menus.menu.battery.border.color": "#414868",
          "theme.bar.menus.menu.battery.background.color": "#1a1b26",
          "theme.bar.menus.menu.battery.card.color": "#24283b",
          "theme.bar.menus.menu.systray.dropdownmenu.divider": "#24283b",
          "theme.bar.menus.menu.systray.dropdownmenu.text": "#c0caf5",
          "theme.bar.menus.menu.systray.dropdownmenu.background": "#1a1b26",
          "theme.bar.menus.menu.bluetooth.iconbutton.active": "#7dcfff",
          "theme.bar.menus.menu.bluetooth.iconbutton.passive": "#c0caf5",
          "theme.bar.menus.menu.bluetooth.icons.active": "#7dcfff",
          "theme.bar.menus.menu.bluetooth.icons.passive": "#565f89",
          "theme.bar.menus.menu.bluetooth.listitems.active": "#7dcfff",
          "theme.bar.menus.menu.bluetooth.listitems.passive": "#c0caf5",
          "theme.bar.menus.menu.bluetooth.switch.puck": "#565f89",
          "theme.bar.menus.menu.bluetooth.switch.disabled": "#565f89",
          "theme.bar.menus.menu.bluetooth.switch.enabled": "#7dcfff",
          "theme.bar.menus.menu.bluetooth.switch_divider": "#414868",
          "theme.bar.menus.menu.bluetooth.status": "#565f89",
          "theme.bar.menus.menu.bluetooth.text": "#c0caf5",
          "theme.bar.menus.menu.bluetooth.label.color": "#7dcfff",
          "theme.bar.menus.menu.bluetooth.border.color": "#414868",
          "theme.bar.menus.menu.bluetooth.background.color": "#1a1b26",
          "theme.bar.menus.menu.bluetooth.card.color": "#24283b",
          "theme.bar.menus.menu.network.iconbuttons.active": "#bb9af7",
          "theme.bar.menus.menu.network.iconbuttons.passive": "#c0caf5",
          "theme.bar.menus.menu.network.icons.active": "#bb9af7",
          "theme.bar.menus.menu.network.icons.passive": "#565f89",
          "theme.bar.menus.menu.network.listitems.active": "#bb9af7",
          "theme.bar.menus.menu.network.listitems.passive": "#c0caf5",
          "theme.bar.menus.menu.network.status.color": "#565f89",
          "theme.bar.menus.menu.network.text": "#c0caf5",
          "theme.bar.menus.menu.network.label.color": "#bb9af7",
          "theme.bar.menus.menu.network.border.color": "#414868",
          "theme.bar.menus.menu.network.background.color": "#1a1b26",
          "theme.bar.menus.menu.network.card.color": "#24283b",
          "theme.bar.menus.menu.volume.input_slider.puck": "#414868",
          "theme.bar.menus.menu.volume.input_slider.backgroundhover": "#414868",
          "theme.bar.menus.menu.volume.input_slider.background": "#565f89",
          "theme.bar.menus.menu.volume.input_slider.primary": "#f7768e",
          "theme.bar.menus.menu.volume.audio_slider.puck": "#414868",
          "theme.bar.menus.menu.volume.audio_slider.backgroundhover": "#414868",
          "theme.bar.menus.menu.volume.audio_slider.background": "#565f89",
          "theme.bar.menus.menu.volume.audio_slider.primary": "#f7768e",
          "theme.bar.menus.menu.volume.icons.active": "#f7768e",
          "theme.bar.menus.menu.volume.icons.passive": "#565f89",
          "theme.bar.menus.menu.volume.iconbutton.active": "#f7768e",
          "theme.bar.menus.menu.volume.iconbutton.passive": "#c0caf5",
          "theme.bar.menus.menu.volume.listitems.active": "#f7768e",
          "theme.bar.menus.menu.volume.listitems.passive": "#c0caf5",
          "theme.bar.menus.menu.volume.border.color": "#414868",
          "theme.bar.menus.menu.volume.background.color": "#1a1b26",
          "theme.bar.menus.menu.media.slider.puck": "#565f89",
          "theme.bar.menus.menu.media.slider.backgroundhover": "#414868",
          "theme.bar.menus.menu.media.slider.background": "#565f89",
          "theme.bar.menus.menu.media.slider.primary": "#f7768e",
          "theme.bar.menus.menu.media.buttons.text": "#1a1b26",
          "theme.bar.menus.menu.media.buttons.background": "#bb9af7",
          "theme.bar.menus.menu.media.buttons.enabled": "#73daca",
          "theme.bar.menus.menu.media.buttons.inactive": "#414868",
          "theme.bar.menus.menu.media.border.color": "#414868",
          "theme.bar.menus.menu.media.background.color": "#1a1b26",
          "theme.bar.menus.menu.media.album": "#f7768e",
          "theme.bar.menus.menu.media.artist": "#73daca",
          "theme.bar.menus.menu.media.song": "#bb9af7",
          "theme.bar.menus.tooltip.text": "#c0caf5",
          "theme.bar.menus.tooltip.background": "#1a1b26",
          "theme.bar.menus.dropdownmenu.divider": "#24283b",
          "theme.bar.menus.dropdownmenu.text": "#c0caf5",
          "theme.bar.menus.dropdownmenu.background": "#1a1b26",
          "theme.bar.menus.slider.puck": "#565f89",
          "theme.bar.menus.slider.backgroundhover": "#414868",
          "theme.bar.menus.slider.background": "#565f89",
          "theme.bar.menus.slider.primary": "#bb9af7",
          "theme.bar.menus.progressbar.background": "#414868",
          "theme.bar.menus.progressbar.foreground": "#bb9af7",
          "theme.bar.menus.iconbuttons.active": "#bb9af7",
          "theme.bar.menus.iconbuttons.passive": "#c0caf5",
          "theme.bar.menus.buttons.text": "#1a1b26",
          "theme.bar.menus.buttons.disabled": "#565f89",
          "theme.bar.menus.buttons.active": "#f7768e",
          "theme.bar.menus.buttons.default": "#06b4bf",
          "theme.bar.menus.switch.puck": "#565f89",
          "theme.bar.menus.switch.disabled": "#565f89",
          "theme.bar.menus.switch.enabled": "#bb9af7",
          "theme.bar.menus.icons.active": "#bb9af7",
          "theme.bar.menus.icons.passive": "#414868",
          "theme.bar.menus.listitems.active": "#bb9af7",
          "theme.bar.menus.listitems.passive": "#c0caf5",
          "theme.bar.menus.label": "#bb9af7",
          "theme.bar.menus.feinttext": "#414868",
          "theme.bar.menus.dimtext": "#414868",
          "theme.bar.menus.cards": "#24283b",
          "theme.bar.buttons.notifications.total": "#bb9af7",
          "theme.bar.buttons.notifications.icon": "#bb9af7",
          "theme.bar.buttons.notifications.background": "#ffffff",
          "theme.bar.buttons.clock.icon": "#f7768e",
          "theme.bar.buttons.clock.text": "#f7768e",
          "theme.bar.buttons.clock.background": "#ffffff",
          "theme.bar.buttons.battery.icon": "#e0af68",
          "theme.bar.buttons.battery.text": "#e0af68",
          "theme.bar.buttons.battery.background": "#ffffff",
          "theme.bar.buttons.systray.background": "#272a3d",
          "theme.bar.buttons.bluetooth.icon": "#7dcfff",
          "theme.bar.buttons.bluetooth.text": "#7dcfff",
          "theme.bar.buttons.bluetooth.background": "#ffffff",
          "theme.bar.buttons.network.icon": "#bb9af7",
          "theme.bar.buttons.network.text": "#bb9af7",
          "theme.bar.buttons.network.background": "#ffffff",
          "theme.bar.buttons.volume.icon": "#f7768e",
          "theme.bar.buttons.volume.text": "#f7768e",
          "theme.bar.buttons.volume.background": "#ffffff",
          "theme.bar.buttons.windowtitle.icon": "#f7768e",
          "theme.bar.buttons.windowtitle.text": "#f7768e",
          "theme.bar.buttons.windowtitle.background": "#ffffff",
          "theme.bar.buttons.workspaces.active": "#f7768e",
          "theme.bar.buttons.workspaces.occupied": "#f7768e",
          "theme.bar.buttons.workspaces.available": "#7dcfff",
          "theme.bar.buttons.workspaces.hover": "#414868",
          "theme.bar.buttons.workspaces.background": "#ffffff",
          "theme.bar.buttons.dashboard.icon": "#e0af68",
          "theme.bar.buttons.dashboard.background": "#ffffff",
          "theme.osd.label": "#bb9af7",
          "theme.osd.icon": "#1a1b26",
          "theme.osd.bar_overflow_color": "#f7768e",
          "theme.osd.bar_empty_color": "#414868",
          "theme.osd.bar_color": "#bb9af7",
          "theme.osd.icon_container": "#bb9af7",
          "theme.osd.bar_container": "#1a1b26",
          "theme.notification.close_button.label": "#1a1b26",
          "theme.notification.close_button.background": "#f7768e",
          "theme.notification.labelicon": "#bb9af7",
          "theme.notification.text": "#c0caf5",
          "theme.notification.time": "#9aa5ce",
          "theme.notification.border": "#565f89",
          "theme.notification.label": "#bb9af7",
          "theme.notification.actions.text": "#24283b",
          "theme.notification.actions.background": "#bb9af7",
          "theme.notification.background": "#1a1b26",
          "theme.bar.buttons.workspaces.numbered_active_highlighted_text_color": "#181825",
          "theme.bar.buttons.workspaces.numbered_active_underline_color": "#c678dd",
          "theme.bar.menus.menu.media.card.color": "#24283b",
          "theme.bar.menus.check_radio_button.background": "#3b4261",
          "theme.bar.menus.check_radio_button.active": "#bb9af7",
          "theme.bar.buttons.style": "default",
          "theme.bar.menus.menu.notifications.pager.button": "#bb9af7",
          "theme.bar.menus.menu.notifications.scrollbar.color": "#bb9af7",
          "theme.bar.menus.menu.notifications.pager.label": "#565f89",
          "theme.bar.menus.menu.notifications.pager.background": "#1a1b26",
          "theme.bar.buttons.clock.icon_background": "#f7768e",
          "theme.bar.buttons.modules.ram.icon": "#e0af68",
          "theme.bar.buttons.modules.storage.icon_background": "#f7768e",
          "theme.bar.menus.popover.border": "#1a1b26",
          "theme.bar.buttons.volume.icon_background": "#f7768e",
          "theme.bar.menus.menu.power.buttons.sleep.icon_background": "#7dcfff",
          "theme.bar.menus.menu.power.buttons.restart.text": "#e0af68",
          "theme.bar.buttons.modules.updates.background": "#272a3d",
          "theme.bar.buttons.modules.storage.icon": "#f7768e",
          "theme.bar.buttons.modules.netstat.background": "#272a3d",
          "theme.bar.buttons.modules.weather.icon": "#bb9af7",
          "theme.bar.buttons.modules.netstat.text": "#9ece6a",
          "theme.bar.buttons.modules.storage.background": "#272a3d",
          "theme.bar.buttons.modules.power.icon": "#f7768e",
          "theme.bar.buttons.modules.storage.text": "#f7768e",
          "theme.bar.buttons.modules.cpu.background": "#272a3d",
          "theme.bar.menus.menu.power.border.color": "#414868",
          "theme.bar.buttons.network.icon_background": "#caa6f7",
          "theme.bar.buttons.modules.power.icon_background": "#f7768e",
          "theme.bar.menus.menu.power.buttons.logout.icon": "#1a1b26",
          "theme.bar.menus.menu.power.buttons.restart.icon_background": "#e0af68",
          "theme.bar.menus.menu.power.buttons.restart.icon": "#1a1b26",
          "theme.bar.buttons.modules.cpu.icon": "#f7768e",
          "theme.bar.buttons.battery.icon_background": "#e0af68",
          "theme.bar.buttons.modules.kbLayout.icon_background": "#7dcfff",
          "theme.bar.buttons.modules.weather.text": "#bb9af7",
          "theme.bar.menus.menu.power.buttons.shutdown.icon": "#1a1b26",
          "theme.bar.menus.menu.power.buttons.sleep.text": "#7dcfff",
          "theme.bar.buttons.modules.weather.icon_background": "#bb9af7",
          "theme.bar.menus.menu.power.buttons.shutdown.background": "#24283b",
          "theme.bar.buttons.media.icon_background": "#bb9af7",
          "theme.bar.menus.menu.power.buttons.logout.background": "#24283b",
          "theme.bar.buttons.modules.kbLayout.icon": "#7dcfff",
          "theme.bar.buttons.modules.ram.icon_background": "#e0af68",
          "theme.bar.menus.menu.power.buttons.shutdown.icon_background": "#f7768e",
          "theme.bar.menus.menu.power.buttons.shutdown.text": "#f7768e",
          "theme.bar.menus.menu.power.buttons.sleep.background": "#24283b",
          "theme.bar.buttons.modules.ram.text": "#e0af68",
          "theme.bar.menus.menu.power.buttons.logout.text": "#9ece6a",
          "theme.bar.buttons.modules.updates.icon_background": "#bb9af7",
          "theme.bar.buttons.modules.kbLayout.background": "#272a3d",
          "theme.bar.buttons.modules.power.background": "#272a3d",
          "theme.bar.buttons.modules.weather.background": "#272a3d",
          "theme.bar.buttons.icon_background": "#272a3d",
          "theme.bar.menus.menu.power.background.color": "#1a1b26",
          "theme.bar.buttons.modules.ram.background": "#272a3d",
          "theme.bar.buttons.modules.netstat.icon": "#9ece6a",
          "theme.bar.buttons.windowtitle.icon_background": "#f7768e",
          "theme.bar.buttons.modules.cpu.icon_background": "#f7768e",
          "theme.bar.menus.menu.power.buttons.logout.icon_background": "#9ece6a",
          "theme.bar.buttons.modules.updates.text": "#bb9af7",
          "theme.bar.menus.menu.power.buttons.sleep.icon": "#1a1b26",
          "theme.bar.buttons.bluetooth.icon_background": "#89dbeb",
          "theme.bar.menus.menu.power.buttons.restart.background": "#24283b",
          "theme.bar.buttons.modules.updates.icon": "#bb9af7",
          "theme.bar.buttons.modules.cpu.text": "#f7768e",
          "theme.bar.buttons.modules.netstat.icon_background": "#9ece6a",
          "theme.bar.buttons.modules.kbLayout.text": "#7dcfff",
          "theme.bar.buttons.notifications.icon_background": "#bb9af7",
          "theme.bar.buttons.modules.power.border": "#f7768e",
          "theme.bar.buttons.modules.weather.border": "#bb9af7",
          "theme.bar.buttons.modules.updates.border": "#bb9af7",
          "theme.bar.buttons.modules.kbLayout.border": "#7dcfff",
          "theme.bar.buttons.modules.netstat.border": "#9ece6a",
          "theme.bar.buttons.modules.storage.border": "#f7768e",
          "theme.bar.buttons.modules.cpu.border": "#f7768e",
          "theme.bar.buttons.modules.ram.border": "#e0af68",
          "theme.bar.buttons.notifications.border": "#bb9af7",
          "theme.bar.buttons.clock.border": "#f7768e",
          "theme.bar.buttons.battery.border": "#e0af68",
          "theme.bar.buttons.systray.border": "#ffffff",
          "theme.bar.buttons.bluetooth.border": "#7dcfff",
          "theme.bar.buttons.network.border": "#bb9af7",
          "theme.bar.buttons.volume.border": "#f7768e",
          "theme.bar.buttons.media.border": "#bb9af7",
          "theme.bar.buttons.windowtitle.border": "#f7768e",
          "theme.bar.buttons.workspaces.border": "#f7768e",
          "theme.bar.buttons.dashboard.border": "#e0af68",
          "theme.bar.buttons.modules.submap.background": "#272a3d",
          "theme.bar.buttons.modules.submap.text": "#73daca",
          "theme.bar.buttons.modules.submap.border": "#73daca",
          "theme.bar.buttons.modules.submap.icon": "#73daca",
          "theme.bar.buttons.modules.submap.icon_background": "#272a3d",
          "theme.bar.menus.menu.network.switch.puck": "#565f89",
          "theme.bar.menus.menu.network.switch.disabled": "#565f89",
          "theme.bar.menus.menu.network.switch.enabled": "#bb9af7",
          "theme.bar.buttons.systray.customIcon": "#c0caf5",
          "theme.bar.border.color": "#bb9af7",
          "theme.bar.menus.menu.media.timestamp": "#c0caf5",
          "theme.bar.buttons.borderColor": "#bb9af7",
          "theme.bar.buttons.modules.hyprsunset.icon": "#e0af68",
          "theme.bar.buttons.modules.hyprsunset.background": "#272a3d",
          "theme.bar.buttons.modules.hyprsunset.icon_background": "#e0af68",
          "theme.bar.buttons.modules.hyprsunset.text": "#e0af68",
          "theme.bar.buttons.modules.hyprsunset.border": "#e0af68",
          "theme.bar.buttons.modules.hypridle.icon": "#f7768e",
          "theme.bar.buttons.modules.hypridle.background": "#272a3d",
          "theme.bar.buttons.modules.hypridle.icon_background": "#f7768e",
          "theme.bar.buttons.modules.hypridle.text": "#f7768e",
          "theme.bar.buttons.modules.hypridle.border": "#f7768e",
          "theme.bar.menus.menu.network.scroller.color": "#bb9af7",
          "theme.bar.menus.menu.bluetooth.scroller.color": "#7dcfff",
          "theme.bar.buttons.modules.cava.background": "#272a3d",
          "theme.bar.buttons.modules.cava.text": "#73daca",
          "theme.bar.buttons.modules.cava.icon": "#73daca",
          "theme.bar.buttons.modules.cava.icon_background": "#272a3d",
          "theme.bar.buttons.modules.cava.border": "#73daca",
          "menus.transition": "crossfade",
          "notifications.position": "top right",
          "menus.clock.weather.location": "Brussels",
          "menus.clock.weather.unit": "metric",
          "menus.clock.time.military": true,
          "bar.launcher.autoDetectIcon": true,
          "bar.battery.hideLabelWhenFull": false,
          "bar.notifications.show_total": false,
          "bar.notifications.hideCountWhenZero": true,
          "theme.bar.transparent": false,
          "theme.bar.opacity": 50,
          "theme.bar.buttons.monochrome": true,
          "wallpaper.enable": false,
          "theme.bar.menus.opacity": 100,
          "theme.bar.menus.border.size": "0.1em",
          "menus.transitionTime": 25,
          "theme.bar.buttons.enableBorders": false,
          "theme.bar.border.width": "0.14em",
          "theme.bar.buttons.y_margins": "0.3em",
          "theme.bar.buttons.padding_y": "0.05rem",
          "bar.clock.format": "%b %d %H:%M",
          "theme.bar.buttons.background_opacity": 15,
          "bar.windowtitle.custom_title": false,
          "theme.bar.menus.card_radius": "0.2em",
          "theme.bar.buttons.background_hover_opacity": 75,
          "theme.bar.menus.buttons.radius": "0.4em",
          "theme.bar.menus.border.radius": "0.7em",
          "theme.bar.buttons.radius": "0.6em",
          "theme.bar.buttons.padding_x": "0.8rem",
          "bar.layouts": {
            "0": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "notifications",
                "clock"
              ],
              "right": [
                "media",
                "systray",
                "hyprsunset",
                "hypridle",
                "volume",
                "network",
                "bluetooth",
                "battery",
                "power"
              ]
            },
            "1": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "volume",
                "clock",
                "notifications"
              ]
            },
            "2": {
              "left": [
                "dashboard",
                "workspaces",
                "windowtitle"
              ],
              "middle": [
                "media"
              ],
              "right": [
                "volume",
                "clock",
                "notifications"
              ]
            }
          },
          "theme.bar.buttons.windowtitle.enableBorder": false,
          "menus.dashboard.shortcuts.left.shortcut1.command": "zen-browser",
          "menus.dashboard.shortcuts.left.shortcut1.tooltip": "Zen Browser",
          "menus.dashboard.shortcuts.left.shortcut1.icon": "",
          "scalingPriority": "hyprland",
          "theme.bar.outer_spacing": "0.2em",
          "bar.customModules.hyprsunset.offIcon": "",
          "bar.customModules.hyprsunset.onIcon": "󰽥",
          "bar.customModules.hypridle.label": false,
          "bar.customModules.hyprsunset.label": false,
          "bar.volume.label": false,
          "bar.bluetooth.label": false,
          "bar.network.label": true,
          "bar.media.show_active_only": true,
          "menus.dashboard.shortcuts.left.shortcut4.command": "ags -i main toggle launcher",
          "menus.dashboard.directories.left.directory3.command": "bash -c \"xdg-open $HOME/projects/\"",
          "bar.customModules.weather.unit": "metric",
          "bar.workspaces.show_icons": false,
          "bar.workspaces.workspaceMask": false,
          "bar.workspaces.showWsIcons": false,
          "bar.workspaces.showApplicationIcons": false,
          "bar.workspaces.ignored": "-.*",
          "bar.windowtitle.class_name": false
        }
      '';
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
        allow_tearing = true;
        gaps_in = 10;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" = "rgba(07b5efff)";
        "col.inactive_border" = "rgba(ffffff00)";
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
          color = "0x66000000";
        };
      };
      master = { new_status = "master"; };
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
          "workspaces, 1, 6, default"
          "specialWorkspace, 1, 4, default, slidevert "
        ];
      };
      exec-once = [
        "hyprpaper"
        "wl-paste --watch cliphist store"
        "walker --gapplication-service"
        "gnome-keyring-daemon --start"
        "easyeffects --gapplication-service"
        "hyprpanel"
        "hypridle"
        "hyprlock"
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
        "$mainMod, d, exec, walker"
        "$mainMod, e, exec, walker -m emojis"
        "$mainMod, c, exec, walker -m clipboard"
        "$mainMod, f, fullscreen,"
        "$mainMod SHIFT, space, togglefloating,"
        "$mainMod,b,exec,brave"
        "alt,L,exec,hyprlock"
        "$mainMod SHIFT, s, exec, hyprshot -m region --freeze"
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
        follow_mouse = 2;
        sensitivity = 0.5;
        repeat_rate = 25;
        repeat_delay = 200;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
      };

      windowrulev2 = [ "opacity 0.9 0.9,class:^(ghostty)$" ];

      "$mainMod" = "SUPER";
    };
  };

  # programs.walker = {
  #   enable = true;
  #   runAsService = true;
  #
  #   config = {
  #     activation_mode.disabled = true;
  #     ignore_mouse = true;
  #   };
  #
  #   theme = {
  #     layout = {
  #       ui.window.box = {
  #         v_align = "center";
  #         orientation = "vertical";
  #       };
  #     };
  #
  #     style = ''
  #       child {
  #         border-radius: 0;
  #       }
  #     '';
  #   };
  # };
}
