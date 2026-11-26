# Headless server baseline: systemd-networkd, LTS kernel, no swap or GUI.
{
  flake.modules.nixos.server =
    { lib, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
      zramSwap.enable = false;
      btrfs-disk.swapSize = lib.mkDefault null;

      networking.useNetworkd = true;
      systemd.network.enable = true;
    };
}
