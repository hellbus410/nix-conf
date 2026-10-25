# NetworkManager, for machines that move between networks or have Wi-Fi; servers use systemd-networkd.
{
  networking.networkmanager.enable = true;
  users.users.demiurge.extraGroups = [ "networkmanager" ];

  environment.persistence."/persist".directories = [
    "/etc/NetworkManager/system-connections" # saved networks, Wi-Fi passwords
    "/var/lib/NetworkManager"
  ];
}
