# ASUS ROG Flow X13 (GV301): PRIME offload with RTD3 (when paired with nvidia), ASUS ROG daemons, 2-in-1 rotation sensor.
{
  flake.modules.nixos.flowX13 =
    { lib, ... }:
    {
      # ── nvidia-powerd ──
      hardware.nvidia.dynamicBoost.enable = true;

      # ── PRIME offload ── (with the nvidia feature) the desktop runs on the integrated Radeon GPU;
      # `nvidia-offload <program>` runs a program on the NVIDIA GPU.
      # lspci -D, XG Mobile detached: 0000:01:00.0 NVIDIA, 0000:08:00.0 Radeon (hex in lspci, decimal here).
      hardware.nvidia.prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        amdgpuBusId = lib.mkDefault "PCI:8:0:0";
      };
      hardware.nvidia.powerManagement = {
        enable = true; # saves video memory across suspend
        finegrained = true; # powers the NVIDIA GPU off when nothing uses it (RTD3)
      };

      # ── ASUS ── asusctl: power profiles, charge limit, keyboard light; supergfxctl: GPU modes and the XG Mobile
      services.asusd.enable = true;
      services.supergfxd.enable = true;
      environment.persistence."/persist".directories = [ "/etc/asusd" ];

      # rog-control-center autostart as systemd user unit
      systemd.user.services.rog-control-center = {
        description = "ROG Control Center";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/rog-control-center";
          Restart = "on-failure";
        };
      };

      # ── 2-in-1 ── accelerometer for screen rotation (iio-sensor-proxy)
      hardware.sensor.iio.enable = true;
    };
}
