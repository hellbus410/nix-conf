# Disk layout: GPT, 1G ESP, one btrfs with @root (wiped), @nix, @persist, @log, @home, @swap,
# optionally inside LUKS. The host sets the disk: disko.devices.disk.main.device = "/dev/disk/by-id/…";
{ inputs, ... }:
{
  flake.modules.nixos.btrfs-disk =
    { config, lib, ... }:
    let
      cfg = config.btrfs-disk;

      btrfs = {
        type = "btrfs";
        extraArgs = [
          "-f"
          "-L"
          "nixos"
        ];
        subvolumes = {
          "@root" = {
            mountpoint = "/";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@persist" = {
            mountpoint = "/persist";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@log" = {
            mountpoint = "/var/log";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@home" = {
            mountpoint = "/home";
            mountOptions = [
              "compress=zstd"
              "noatime"
            ];
          };
          "@swap" = {
            mountpoint = "/.swapvol";
            swap.swapfile.size = "8G";
          };
        };
      };
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      options.btrfs-disk = {
        luks = lib.mkEnableOption "LUKS around the btrfs partition; the passphrase is asked in the initrd";
        device = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          description = "The block device holding the btrfs filesystem: the partition, or the opened LUKS mapping.";
        };
      };

      config = {
        btrfs-disk.device =
          if cfg.luks then
            "/dev/mapper/cryptroot"
          else
            config.disko.devices.disk.main.content.partitions.root.device; # /dev/disk/by-partlabel/disk-main-root

        disko.devices = {
          disk = {
            main = {
              type = "disk";

              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    size = "1G";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };

                  root = {
                    size = "100%";
                    content =
                      if cfg.luks then
                        {
                          type = "luks";
                          name = "cryptroot";
                          settings.allowDiscards = true; # TRIM through LUKS
                          content = btrfs; # disko asks for the passphrase when it formats
                        }
                      else
                        btrfs;
                  };
                };
              };
            };
          };
        };

        # Mounted in the initrd, before the persistence bind mounts need them.
        fileSystems."/persist".neededForBoot = true;
        fileSystems."/var/log".neededForBoot = true;

        services.btrfs.autoScrub = {
          enable = true;
          interval = "monthly";
          fileSystems = [ "/" ];
        };
      };
    };
}
