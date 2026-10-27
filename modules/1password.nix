# 1Password, system-level: setgid CLI wrapper, polkit policy.
{ inputs, ... }:
{
  flake.modules.nixos."1password" =
    { pkgs, ... }:
    let
      # TEMP: GUI from the pinned nixpkgs (see flake.nix); the CLI stays on unstable.
      pinned = import inputs.nixpkgs-1password {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        package = pinned._1password-gui;
        polkitPolicyOwners = [ "demiurge" ];
      };
    };
}
