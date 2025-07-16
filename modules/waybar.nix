{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      reload_style_on_change = true;
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "group/tray-expander"
        "idle_inhibitor"
        "temperature"
        "memory"
        "bluetooth"
        "network"
        "pulseaudio"
        "cpu"
        "battery"
        "custom/notification"
      ];

      # Workspace Module
      hyprland.workspaces = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };

      # Window Title Module
      hyprland.window = {
        format = "{title}";
        max-length = 50;
        tooltip = false;
        rewrite = {
          "^(.*) — Mozilla Firefox$" = "🌐 $1";
          "^(.*) - Visual Studio Code$" = "💻 $1";
          "^(.*) - Alacritty$" = "  $1";
        };
      };

      # CPU Module
      cpu = {
        interval = 5;
        format = "󰍛 {usage}%";
        on-click = "alacritty -e btop";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      # Memory Module
      memory = {
        interval = 5;
        format = "󰾆 {percentage}%";
        tooltip-format = "RAM: {used:0.1f}G/{total:0.1f}G ({percentage}%)\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G";
        on-click = "alacritty -e btop";
        states = {
          warning = 70;
          critical = 85;
        };
      };

      # Temperature Module
      temperature = {
        interval = 5;
        format = "󰔏 {temperatureC}°C";
        critical-threshold = 80;
        format-critical = "󰸁 {temperatureC}°C";
        tooltip-format = "CPU Temperature: {temperatureC}°C";
      };

      # Clock Module
      clock = {
        format = "{:%A %H:%M}";
        format-alt = "{:%d %B W%V %Y}";
        tooltip-format = "{:%A, %d %B %Y}\n{calendar}";
        calendar = {
          mode = "month";
          format = {
            months = "<span color='#cdd6f4'><b>{}</b></span>";
            days = "<span color='#cdd6f4'><b>{}</b></span>";
            weekdays = "<span color='#89b4fa'><b>{}</b></span>";
            today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      # Network Module
      network = {
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format = "{icon}";
        format-wifi = "{icon} {signalStrength}%";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\nSignal: {signalStrength}%\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        nospacing = 1;
        on-click = "alacritty --class=Impala -e impala";
      };

      # Battery Module
      battery = {
        format = "{capacity}% {icon}";
        format-discharging = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-icons = {
          charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
          default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        format-full = "󰂅";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}% ({time})";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}% ({time})";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
      };

      # Bluetooth Module
      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-connected = "󰂱 {num_connections}";
        tooltip-format = "Devices connected: {num_connections}";
        tooltip-format-connected = "{device_alias} {device_battery_percentage}%";
        on-click = "GTK_THEME=Adwaita-dark blueberry";
      };

      # Pulseaudio Module
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        on-click = "GTK_THEME=Adwaita-dark pavucontrol";
        on-click-right = "pamixer -t";
        tooltip-format = "Playing at {volume}%";
        scroll-step = 5;
        format-icons = {
          default = ["󰕿" "󰖀" "󰕾"];
          headphone = "󰋋";
          headset = "󰋎";
          phone = "󰄜";
          portable = "󰦧";
          car = "󰄋";
        };
      };

      # Idle Inhibitor Module
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰅶";
          deactivated = "󰾪";
        };
        tooltip-format-activated = "Idle inhibitor: ON";
        tooltip-format-deactivated = "Idle inhibitor: OFF";
      };

      # Custom Notification Module
      custom.notification = {
        format = "󰂚";
        tooltip = false;
        on-click = "swaync-client -t";
        on-click-right = "swaync-client -d";
      };

      # Tray Expander Group
      group.tray-expander = {
        orientation = "inherit";
        drawer = {
          transition-duration = 600;
          children-class = "tray-group-item";
        };
        modules = [
          "custom/expand-icon"
          "tray"
        ];
      };

      # Custom Expand Icon
      custom.expand-icon = {
        format = " ";
        tooltip = false;
      };

      # Tray
      tray = {
        icon-size = 12;
        spacing = 12;
      };
    }];

    style = ''
      @define-color foreground #cdd6f4;
      @define-color background #1a1b26;
      @define-color warning #fab387;
      @define-color critical #f38ba8;
      
      * {
        background-color: @background;
        color: @foreground;
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: CaskaydiaMono Nerd Font Propo;
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
      }

      #window {
        margin: 0 12px;
        font-style: italic;
        color: #89b4fa;
      }

      #tray,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #network,
      #bluetooth,
      #pulseaudio,
      #clock,
      #idle_inhibitor,
      #custom-notification,
      #custom-power-menu {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #custom-expand-icon {
        margin-right: 12px;
      }

      #cpu.warning,
      #memory.warning,
      #temperature.warning,
      #battery.warning {
        color: @warning;
      }

      #cpu.critical,
      #memory.critical,
      #temperature.critical,
      #battery.critical {
        color: @critical;
      }

      #idle_inhibitor.activated {
        color: #f9e2af;
      }

      tooltip {
        padding: 2px;
      }
    '';
  };
}
