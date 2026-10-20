# Chat and mail.
{ pkgs, ... }:
{
  home-manager.users.demiurge.home.packages = with pkgs; [
    vesktop
    telegram-desktop
    protonmail-desktop
  ];
}
