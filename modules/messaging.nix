# Chat and mail.
{
  flake.modules.homeManager.messaging =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vesktop
        telegram-desktop
        protonmail-desktop
      ];
    };
}
