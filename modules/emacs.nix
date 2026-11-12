# DOOM in a trenchcoat
{
  flake.modules.homeManager.emacs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        emacs-nox
      ];
    };
}
