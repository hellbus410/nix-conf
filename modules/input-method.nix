# Typing in other languages: fcitx5 with Mozc for Japanese. Layouts: US / RU / JP.
{
  flake.modules.nixos.input-method =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
          ];
        };
      };
    };
}
