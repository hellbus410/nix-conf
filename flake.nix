{
  description = "initial NixOS configuration for bifrost";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      # excluding nixpkgs from flake.lock file from impermanence
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations = {
        bifrost = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs self; };
          modules = [ ./hosts/bifrost ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
