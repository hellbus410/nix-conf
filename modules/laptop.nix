# Laptop: the ASUS ROG daemons, the NVIDIA GPU as an offload GPU that powers off when idle, screen rotation.
# Lid and suspend stay at logind's defaults (suspend; ignored when docked).
# The host sets the GPUs' bus ids: hardware.nvidia.prime.{amdgpuBusId,nvidiaBusId}.
{
  flake.modules.nixos.laptop = {
    # ── PRIME offload ── (with the nvidia feature) the desktop runs on the integrated GPU;
    # `nvidia-offload <program>` runs a program on the NVIDIA one
    hardware.nvidia.prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    hardware.nvidia.powerManagement = {
      enable = true; # saves video memory across suspend
      finegrained = true; # powers the NVIDIA GPU off when nothing uses it (RTD3)
    };

    # ── ASUS ── asusctl: power profiles, charge limit, keyboard light; supergfxctl: GPU modes and the XG Mobile
    services.asusd.enable = true;
    services.supergfxd.enable = true;
    # asusd writes its own config here (charge limit, profiles); supergfxd's mode resets to Hybrid at boot
    environment.persistence."/persist".directories = [ "/etc/asusd" ];

    # ── 2-in-1 ── the accelerometer, for screen rotation (iio-sensor-proxy)
    hardware.sensor.iio.enable = true;
  };
}
