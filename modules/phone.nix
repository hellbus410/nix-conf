# Phone: Valent (KDE Connect protocol). Opens TCP/UDP 1714-1764; uwsm runs its xdg autostart.
{
  flake.modules.nixos.phone =
    { pkgs, ... }:
    {
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };
    };
}
