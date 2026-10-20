# Office documents. The fonts they ask for join from desktop.nix in a later commit.
{ pkgs, ... }:
{
  home-manager.users.demiurge.home.packages = with pkgs; [
    onlyoffice-desktopeditors
  ];
}
