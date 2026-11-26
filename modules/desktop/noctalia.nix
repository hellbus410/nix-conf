# Noctalia Wayland shell: upstream NixOS module + graphical-session.target user service.
{
  flake.modules.nixos.desktop =
    { config, lib, ... }:
    lib.mkIf (config.desktop.shell == "noctalia") {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };
}
