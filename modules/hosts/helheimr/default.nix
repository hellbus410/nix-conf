# helheimr: ASUS ROG Flow X13 GV301QC, Ryzen 9 5980HS, RTX 3050 Mobile 4 GB, 32 GB, 1 TB NVMe.
{ config, inputs, ... }:
{
  hosts.helheimr = {
    features = [
      "btrfs-disk"
      "impermanence"
    ]
    ++ config.roles.laptop
    ++ [
      "nvidia"
      "clash-verge"
    ];

    module =
      { config, ... }:
      {
        imports = [ ./_hardware.nix ];

        disko.devices.disk.main.device = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPTPZ-1T00-1002_2122C9458611";
        btrfs-disk.luks = true;
        user.name = "hel";

        # lspci -D, XG Mobile detached: 0000:01:00.0 NVIDIA, 0000:08:00.0 Radeon (hex in lspci, decimal here)
        hardware.nvidia.prime = {
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:8:0:0";
        };

        system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
        system.stateVersion = "26.11"; # initial ver.
        home-manager.users.${config.user.name}.home.stateVersion = "26.11"; # initial ver.
      };
  };
}
