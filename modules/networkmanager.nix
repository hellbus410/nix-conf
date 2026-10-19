# NetworkManager, for machines that move between networks or have Wi-Fi; servers use systemd-networkd.
# Its state dirs are persisted in the host's impermanence.nix for now.
{
  networking.networkmanager.enable = true;
  users.users.demiurge.extraGroups = [ "networkmanager" ];
}
