# Root wiped on every boot; what survives lives in /persist.
{ inputs, lib, ... }:
let
  device = "/dev/disk/by-partlabel/disk-main-root"; # disko's label: disk-<disk>-<partition>
  deviceUnit = "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device"; # systemd-escape -p of the above

  # false for the first boot after the reinstall; true once the bind mounts are checked.
  rollback.enable = false;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # Rollback, as a systemd initrd unit (stage 1 runs systemd by default).
  boot.initrd.systemd.services.rollback = lib.mkIf rollback.enable {
    description = "Move the old btrfs root aside and create an empty one";
    wantedBy = [ "initrd.target" ];
    requires = [ deviceUnit ];
    after = [ deviceUnit ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /btrfs_tmp
      mount -o subvolid=5 ${device} /btrfs_tmp # the btrfs top level

      # Keep the old root for 30 days in old_roots/<timestamp>.
      if [[ -e /btrfs_tmp/@root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@root)" "+%Y-%m-%d_%H:%M:%S")
        mv /btrfs_tmp/@root "/btrfs_tmp/old_roots/$timestamp"
      fi

      # Nested subvolumes (systemd creates some) must go before their parent.
      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@root
      umount /btrfs_tmp
    '';
  };

  # Bind-mounted back from /persist/<same path>; anything not listed is lost at reboot.
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos" # UID/GID map
      "/var/lib/systemd" # timers, coredumps
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      {
        directory = "/var/cache/tuigreet"; # --remember state; must belong to greeter
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # /etc/shadow is wiped too, so users are declarative and the hash lives on /persist (never in the public repo).
  users.mutableUsers = false;
  users.users.demiurge.hashedPasswordFile = "/persist/secrets/demiurge.passwd";
}
