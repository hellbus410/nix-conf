# Laptop: the ASUS ROG daemons, the NVIDIA GPU as an offload GPU that powers off when idle, screen rotation.
# Lid: logind locks the session when undocked and ignores the lid when docked; the compositor turns the panel off.
# The host sets the GPUs' bus ids: hardware.nvidia.prime.{amdgpuBusId,nvidiaBusId}.
{
  flake.modules.nixos.laptop = {
    # ── nvidia-powerd ──
    hardware.nvidia.dynamicBoost.enable = true;

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
    environment.persistence."/persist".directories = [ "/etc/asusd" ];

    # rog-control-center autostart as systemd unit
    systemd.user.services.rog-control-center = {
      description = "ROG Control Center";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/rog-control-center";
        Restart = "on-failure";
      };
    };

    # ── 2-in-1 ── the accelerometer, for screen rotation (iio-sensor-proxy)
    hardware.sensor.iio.enable = true;

    # ── Lid ── logind.conf(5): "docked" = in a dock or more than one display connected.
    # "lock" only sends Lock to the sessions
    # HandleLidSwitchExternalPower is left unset, so AC and battery behave the same.
    services.logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchDocked = "ignore"; # the default, stated because the bind in Hyprland relies on it
    };
  };
}
