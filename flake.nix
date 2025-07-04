{
  description = "ofrades NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        configuration = lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/configuration.nix ];
        };
      };
      homeConfigurations = {
        ofrades = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
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
