# Roles: feature lists shared by machines of one kind.
# Software lives in roles; host files keep only hardware traits (nvidia, flowX13) and machine-specific settings.
{ lib, ... }:
let
  core = [
    "core"
    "btrfs-disk"
    "impermanence"
    "sops"
    "cli"
  ];

  desktop = core ++ [
    "networkmanager"
    "audio"
    "bluetooth"
    "desktop"
    "input-method"
    "1password"
    "phone"
    "office"
    "media"
    "browsers"
    "messaging"
    "notes"
    "emacs"
    "dev"
    "podman"
    "ai"
    "games"
    "remote"
    "periphery"
    "adguardhome"
    "searxng"
    "clash-verge"
    "tailscale"
    "nas-media"
  ];

  laptop = desktop ++ [ "laptop" ];

  server = core ++ [ "server" ];
in
{
  options.roles = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    default = { };
    description = "Named feature lists.";
  };

  config.roles = {
    inherit
      core
      desktop
      laptop
      server
      ;
  };
}
