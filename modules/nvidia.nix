# NVIDIA's proprietary driver with the open kernel modules (Turing and newer).
{
  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ]; # selects the driver for Wayland too
      hardware.nvidia = {
        open = true; # NVIDIA's open kernel modules; nouveau and nova stay blacklisted
        modesetting.enable = true; # required by Wayland; already the default
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        nvidiaSettings = false;
      };
    };
}
