# Generic laptop behaviour: battery/power profiles and lid policy.
# Model-specific daemons and hybrid GPU wiring live in their own module (e.g. flowX13.nix).
{
  flake.modules.nixos.laptop =
    { lib, ... }:
    {
      services.upower.enable = true;
      services.power-profiles-daemon.enable = lib.mkDefault true;

      # logind.conf(5): "docked" = in a dock or more than one display connected.
      # "lock" only sends Lock to the sessions; HandleLidSwitchExternalPower is left unset so AC and battery match.
      services.logind.settings.Login = {
        HandleLidSwitch = "lock";
        HandleLidSwitchDocked = "ignore"; # stated explicitly because the bind in Hyprland relies on it
      };
    };
}
