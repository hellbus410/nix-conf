# Games. Steam joins from desktop.nix in a later commit.
{ pkgs, ... }:
{
  # ntsync module for Endfield Anti-cheat
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''
    KERNEL=="ntsync", MODE="0666"
  '';

  home-manager.users.demiurge.home.packages = with pkgs; [
    protonplus
    smassh # monkey type
  ];
}
