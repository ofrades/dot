{ config, inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    gnome-control-center
    gnome-settings-daemon
    polkit_gnome
    adwaita-icon-theme
    papirus-icon-theme
    xdg-utils
    gtk3
    gtk4
    nautilus # File manager
    gnome-disk-utility # Disk management
    gnome-system-monitor # System monitor
    dconf-editor # Advanced configuration
    eog # Image viewer
    evince # Document viewer
    file-roller # Archive manager
    gedit # Text editor
    yaru-theme
    glib
    papers
    gnome-calculator
    gnome-calendar
    gnome-font-viewer
    gnome-screenshot
    simple-scan # Scanner app
    tokyonight-gtk-theme
    papirus-icon-theme
  ];
}
