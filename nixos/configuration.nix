{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec".device =
    "/dev/disk/by-uuid/c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec";
  boot.kernelParams =
    [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia-drm.modeset=1" ];
  networking.hostName = "ofrades";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.printing.enable = true;
  hardware.graphics.enable = true;
  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "ofrades";
      };
      default_session = initial_session;
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.ofrades = {
    isNormalUser = true;
    description = "Miguel Bastos";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    brave
    docker
    nodejs
    python3
    ghostty
    zig
    pavucontrol
    gnome.gnome-control-center
    gnome.gnome-settings-daemon
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };
  system.stateVersion = "24.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
