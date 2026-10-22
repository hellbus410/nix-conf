# bifrost: i7-9700K, RTX 2080 Ti, 16 GB, 2 TB NVMe.
{ self, ... }:
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
    ../../modules/cli.nix
    ../../modules/dev.nix
    ../../modules/desktop.nix
    ../../modules/input-method.nix
    ../../modules/1password.nix
    ../../modules/phone.nix
    ../../modules/office.nix
    ../../modules/media.nix
    ../../modules/browsers.nix
    ../../modules/messaging.nix
    ../../modules/notes.nix
    ../../modules/ai.nix
    ../../modules/nvidia.nix
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

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = "26.05"; # initial ver.
  home-manager.users.demiurge.home.stateVersion = "26.11"; # initial ver.
}
