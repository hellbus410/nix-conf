# The NAS media share; nofail + timeout so boot doesn't wait for the NAS.
{
  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nas-media" = {
    device = "10.41.13.6:/media";
    fsType = "nfs";
    options = [ "_netdev" "nofail" "x-systemd.mount-timeout=10s" "nfsvers=4" ];
  };
}
