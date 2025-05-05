{
  description = "ofrades NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nvidia = lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/configuration-nvidia.nix ];
        };

        normal = lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/configuration.nix ];
        };
      };
      homeConfigurations = {
        ofrades = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.hyprpanel.overlay ];
          };
          modules = [ ./home-manager/home.nix ];

          extraSpecialArgs = {
            inherit system;
            inherit inputs;
          };
        };
      };
    };
}
