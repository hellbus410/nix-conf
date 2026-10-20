# Note-taking apps.
{ pkgs, ... }:
{
  home-manager.users.demiurge.home.packages = with pkgs; [
    obsidian
    zennotes-desktop
  ];
}
