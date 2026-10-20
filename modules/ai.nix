# AI assistants.
{ pkgs, ... }:
{
  home-manager.users.demiurge.home.packages = with pkgs; [
    claude-code
    herdr # TODO: try claude-code using herdr
  ];
}
