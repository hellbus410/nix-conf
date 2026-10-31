# Note-taking apps.
{
  flake.modules.homeManager.notes =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        obsidian
        zennotes-desktop
      ];
    };
}
