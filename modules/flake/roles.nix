# Roles: feature lists shared by machines of one kind. A host takes a role and adds its extras;
# the disk layout is the host's choice, so it is not in a role.
{ lib, ... }:
let
  workstation = [
    "core"
    "networkmanager"
    "audio"
    "bluetooth"
    "games"
    "cli"
    "dev"
    "podman"
    "desktop"
    "input-method"
    "1password"
    "phone"
    "office"
    "media"
    "browsers"
    "messaging"
    "notes"
    "ai"
    "adguardhome"
    "searxng"
    "tailscale"
  ];
in
{
  options.roles = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    default = { };
    description = "Named feature lists.";
  };

  config.roles = {
    inherit workstation;
    laptop = workstation ++ [ "laptop" ]; # the laptop feature comes with helheimr
  };
}
