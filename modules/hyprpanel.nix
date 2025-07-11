{ config, pkgs, ... }:

{
  programs.hyprpanel = {
    enable = true;
    settings = {
      theme.matugen = true;
      wallpaper.image = "${config.home.homeDirectory}/dot/wallpaper_day.png";
      theme.matugen_settings.mode = "dark";
      theme.font.name = "${config.stylix.fonts.monospace.name}";
      theme.font.size = "${toString config.stylix.fonts.sizes.desktop}px";

      bar.transparent = true;
      bar.opacity = 0.5;
      bar.transparentButtons = false;

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
}
