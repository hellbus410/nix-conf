# Games. Steam joins from desktop.nix and ProtonPlus from packages.nix in later commits.
{
  # ntsync module for Endfield Anti-cheat
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0666"
  '';
}
