# bifrost: i7-9700K, RTX 2080 Ti, 16 GB, 2 TB NVMe.
{ config, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./impermanence.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/packages.nix
  ];

  networking.hostName = "bifrost";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ]; # selects the driver for Wayland too
  hardware.nvidia = {
    open = true; # NVIDIA's open kernel modules (Turing and newer); nouveau and nova stay blacklisted
    modesetting.enable = true; # required by Wayland; already the default
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = false;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = "26.05"; # initial ver.
}
