{ config, inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    polkit_gnome
    gnome.adwaita-icon-theme
    gnome.papirus-icon-theme
    xdg-utils
    gtk3
    gtk4
    gnome.gnome-terminal
    gnome.gnome-weather
    gnome.gnome-maps
    gnome.gnome-contacts
    gnome.nautilus # File manager
    gnome.gnome-disk-utility # Disk management
    gnome.gnome-system-monitor # System monitor
    gnome.gnome-control-center # Settings center
    gnome.gnome-tweaks # Additional settings
    gnome.dconf-editor # Advanced configuration
    gnome.eog # Image viewer
    gnome.evince # Document viewer
    gnome.file-roller # Archive manager
    gnome.gedit # Text editor
    yaru-theme
    glib
    gnome.gnome-bluetooth
    blueman # Bluetooth manager
    networkmanagerapplet # Network manager
    gnome.gnome-calculator
    gnome.gnome-calendar
    gnome.gnome-font-viewer
    gnome.gnome-screenshot
    gnome.simple-scan # Scanner app
  ];

  programs.dconf.enable = true;
}
