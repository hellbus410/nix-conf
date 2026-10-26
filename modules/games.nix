# Games: Steam, ProtonPlus, and the ntsync module some anti-cheats need.
{
  flake.modules.nixos.games = {
    programs.steam.enable = true;

    # ntsync module for Endfield Anti-cheat
    boot.kernelModules = [ "ntsync" ];
    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0666"
    '';
  };

  flake.modules.homeManager.games =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        protonplus
        smassh # monkey type
      ];
    };
}
