# bifrost: i7-9700K, RTX 2080 Ti, 16 GB, 2 TB NVMe.
{ config, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./impermanence.nix
    ../../modules/core.nix
    ../../modules/networkmanager.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/games.nix
    ../../modules/desktop.nix
    ../../modules/packages.nix
  ];

  networking.hostName = "bifrost";

  # NVMe dropped off the PCIe bus (controller is down, CSTS=0xffffffff); no NVMe/PCIe power saving.
  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "pcie_aspm=off"
    "pcie_port_pm=off"
  ];

  # NAS media share; nofail + timeout so boot doesn't wait for the NAS
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas-media" = {
    device = "10.41.13.6:/media";
    fsType = "nfs";
    options = [ "_netdev" "nofail" "x-systemd.mount-timeout=10s" "nfsvers=4" ];
  };

  # Never sleep: Hyprland crashes when the monitor drops off and comes back.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

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
