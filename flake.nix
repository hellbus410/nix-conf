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

    import-tree.url = "github:vic/import-tree";
  };

  # Every .nix file under these folders is a flake-parts module; paths with `/_` are skipped.
  # The old NixOS modules in modules/*.nix aren't flake-parts modules yet, so only these two
  # folders are loaded; this becomes ./modules once those are converted.
  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree [
      ./modules/flake
      ./modules/hosts
    ]);
}
