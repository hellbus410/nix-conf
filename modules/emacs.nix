# DOOM in a trenchcoat
{
  flake.modules.homeManager.emacs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        emacs-nox
        (aspellWithDicts (
          dicts: with dicts; [
            en
            ru
          ]
        ))
        nerd-fonts.symbols-only
        symbola
      ];
    };
}
