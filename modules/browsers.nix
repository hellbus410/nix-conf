# Web browsers: Zen as the main one, qutebrowser and Brave.
{ inputs, pkgs, ... }:
{
  home-manager.users.demiurge = {
    imports = [ inputs.zen-browser.homeModules.beta ];

    home.packages = with pkgs; [
      qutebrowser
      brave-origin
    ];

    programs.zen-browser = {
      enable = true;
      # Firefox uses its own GTK dialog outside Flatpak; 1 = always ask the portal (yazi)
      policies.Preferences."widget.use-xdg-desktop-portal.file-picker" = {
        Value = 1;
        Status = "locked";
      };
    };
  };
}
