{ config, pkgs, ... }:
let
  lts = pkgs.linuxPackages_5_15;
  nvidiaDrv = lts.nvidiaPackages.beta;
in {
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec".device =
    "/dev/disk/by-uuid/c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec";
  boot.kernelPackages = lts;

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

  services = {
    # Basic GNOME system services
    gvfs.enable = true; # File system support for applications
    flatpak.enable = true;

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "ofrades";
        };
        default_session = initial_session;
      };
    };

    gnome = {
      evolution-data-server.enable = true; # Calendar, contacts, tasks
      gnome-keyring.enable = true; # Secure credential storage
      gnome-online-accounts.enable = true; # Online account integration
      sushi.enable = true; # File previewer for Nautilus
    };

    # Printer support
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
      ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true; # Enable ALSA support
      alsa.support32Bit = true; # Enable 32-bit ALSA support
      pulse.enable = true; # PulseAudio compatibility
      jack.enable = true; # JACK compatibility
      wireplumber.enable = true;
    };
  };

  hardware.nvidia = {
    open = false;
    package = nvidiaDrv;
    modesetting.enable = true;
    powerManagement.enable = false; # Keep this disabled as in your config
    nvidiaSettings = true; # Add this for NVIDIA settings utility
    forceFullCompositionPipeline = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Only keep the essential NVIDIA-related ones here
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    NVD_BACKEND = "direct";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # install the VA‑API wrapper for NVIDIA so chromium/Brave can do hw decode
    extraPackages = with pkgs;
      [ nvidia-vaapi-driver ]; # :contentReference[oaicite:1]{index=1}
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.rtkit.enable = true;

  # Ensure sound support
  hardware.pulseaudio.enable = false;

  users.users.ofrades = {
    isNormalUser = true;
    description = "Miguel Bastos";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    docker
    nodejs
    python3
    ghostty
    zig
    alsa-utils
    pavucontrol
    easyeffects
    vlc
    xdg-desktop-portal-gtk
  ];

  powerManagement.cpuFreqGovernor = "performance";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  system.stateVersion = "24.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
