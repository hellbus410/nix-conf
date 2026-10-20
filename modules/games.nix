# Games: Steam, ProtonPlus, and the ntsync module some anti-cheats need.
{ pkgs, ... }:
{
  programs.steam.enable = true;

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
