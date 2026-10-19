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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      # excluding nixpkgs from flake.lock file from impermanence
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };

      flake = {
        nixosConfigurations = {
          bifrost = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              inherit (inputs) self;
            };
            modules = [ ./hosts/bifrost ];
          };
        };
      };
    };
}
