# bifrost: i7-9700K, RTX 2080 Ti, 16 GB, 2 TB NVMe.
{ config, inputs, ... }:
{
  hosts.bifrost = {
    features = [
      "btrfs-disk"
      "impermanence"
    ]
    ++ config.roles.workstation
    ++ [
      "nvidia"
      "nas-media"
      "clash-verge"
    ];

    module =
      { config, ... }:
      {
        imports = [ ./_hardware.nix ];

        disko.devices.disk.main.device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NG0M903142J";

        # NVMe dropped off the PCIe bus (controller is down, CSTS=0xffffffff); no NVMe/PCIe power saving.
        boot.kernelParams = [
          "nvme_core.default_ps_max_latency_us=0"
          "pcie_aspm=off"
          "pcie_port_pm=off"
        ];

        # Never sleep: Hyprland crashes when the monitor drops off and comes back.
        systemd.sleep.settings.Sleep = {
          AllowSuspend = "no";
          AllowHibernation = "no";
          AllowHybridSleep = "no";
          AllowSuspendThenHibernate = "no";
        };

        system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
        system.stateVersion = "26.05"; # initial ver.
        home-manager.users.${config.user.name}.home.stateVersion = "26.11"; # initial ver.
      };
  };
}
