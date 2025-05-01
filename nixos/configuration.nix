{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec".device =
    "/dev/disk/by-uuid/c939a0f2-eeaf-4e5b-933b-b45a5ae5e5ec";
  boot.kernelParams =
    [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" "nvidia-drm.modeset=1" ];
  networking.hostName = "ofrades";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd"; # Modern WiFi backend
  };
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

  services = {
    # Basic GNOME system services
    gvfs.enable = true; # File system support for applications
    flatpak.enable = true;

    xserver = {
      enable = true;
      displayManager = { defaultSession = "hyprland"; };
      videoDrivers = [ "nvidia" ];
    };
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
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      extraConfig.pipewire."context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
      };
    };
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

  hardware.graphics.enable = true;

  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  security.rtkit.enable = true;

  # Ensure sound support
  hardware.pulseaudio.enable = false;

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
    docker
    nodejs
    python3
    ghostty
    zig
    alsa-utils
    pavucontrol
    wireplumber
    vlc
    gnome.gnome-control-center
    gnome.gnome-settings-daemon
    pkgs.xdg-desktop-portal-gtk
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
