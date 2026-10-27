{
  description = "NixOS configurations for the homelab, one feature per file";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # TEMP: 1password-gui 8.12.42 aborts on start (chrome_crashpad_handler not patched for NixOS).
    # Pinned to the last nixpkgs with 8.12.38; drop once unstable ships a fixed build.
    nixpkgs-1password.url = "github:nixos/nixpkgs/39ad350a0602fa0a58a544344e3e9187526ea45c";

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

  # Every .nix file under ./modules is a flake-parts module; paths with `/_` are skipped.
  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);
}
