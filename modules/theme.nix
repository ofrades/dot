{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.stylix.homeModules.stylix ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Caskaydia Mono Nerd Font" ];
    };
  };
  home.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-mono
    jetbrains-mono
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    # base16Scheme = {
    #   base00 = "262624"; # "#262624" Default Background (sepia-900)
    #   base01 = "2B2B29"; # "#2B2B29" Lighter Background (sepia-800)
    #   base02 = "32302f"; # "#32302f" Selection Background (sepia-700)
    #   base03 = "40403C"; # "#40403C" Comments (sepia-600)
    #   base04 = "7c6f64"; # "#7c6f64" Dark Foreground (sepia-500)
    #   base05 = "cba57e"; # "#cba57e" Default Foreground (sepia-400)
    #   base06 = "e2c1a2"; # "#e2c1a2" Light Foreground (sepia-300)
    #   base07 = "f4eadd"; # "#f4eadd" Lightest Foreground (sepia-50)
    #   base08 = "CB231C"; # "#CB231C" Red/Error (your red)
    #   base09 = "C96442"; # "#C96442" Orange/Constants (your orange)
    #   base0A = "d4a574"; # "#d4a574" Yellow/Strings (warm yellow derived)
    #   base0B = "7F7F5C"; # "#7F7F5C" Green/Strings (your olive)
    #   base0C = "429D67"; # "#429D67" Cyan/Escape chars (soft green)
    #   base0D = "008588"; # "#008588" Blue/Functions (warm brown-blue)
    #   base0E = "C65F88"; # "#C65F88" Magenta/Keywords (warm mauve)
    #   base0F = "EA9A00"; # "#EA9A00" Brown/Deprecated (warm brown)
    # };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    image = pkgs.fetchurl {
      url =
        "https://raw.githubusercontent.com/ofrades/dot/master/wallpaper_day.png";
      hash = "sha256-Ucip9taI9AcKyW7gYeGHF1LROpZR/ejbnboW/70ogY4=";
    };

    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.caskaydia-mono;
        name = "Caskaydia Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 10;
        terminal = 10;
        desktop = 10;
        popups = 10;
      };
    };

    opacity = {
      desktop = 0.5;
      terminal = 0.9;
    };
    targets.neovim.enable = false;
  };
}
