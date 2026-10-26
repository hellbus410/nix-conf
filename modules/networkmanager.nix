# NetworkManager, for machines that move between networks or have Wi-Fi; servers use systemd-networkd.
{
  flake.modules.nixos.networkmanager =
    { config, ... }:
    {
      networking.networkmanager.enable = true;
      users.users.${config.user.name}.extraGroups = [ "networkmanager" ];

      environment.persistence."/persist".directories = [
        "/etc/NetworkManager/system-connections" # saved networks, Wi-Fi passwords
        "/var/lib/NetworkManager"
      ];
    };
}
