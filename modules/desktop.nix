# The graphical session: settings only — its programs are in packages.nix, its config files in chezmoi.
{ config, pkgs, ... }:
{
  # ── Hyprland ──
  programs.hyprland.enable = true; # session file, portal, polkit, wrappers
  programs.hyprland.withUWSM = true; # OPEN: uwsm or plain
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # file chooser
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Electron apps on Wayland

  # ── Login: greetd + tuigreet ──
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  };

  # ── Fonts ──
  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      nerd-fonts.blex-mono
      ibm-plex
      openmoji-color
      maple-mono.NF
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "IBM Plex Sans" ];
        serif = [ "IBM Plex Serif" ];
        monospace = [ "Terminess Nerd Font" ];
        emoji = [ "OpenMoji Color" ];
      };
    };
    enableDefaultFonts = true;
  };

  # ── Input method: US / RU / JP ──
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

  # ── 1Password ── (system-level: setgid CLI wrapper, polkit policy)
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "demiurge" ];
  };

  # ── Services the Caelestia shell reads ──
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.i2c.enable = true; # external monitor brightness (ddcutil)

  # ── Polkit agent ── (the shell has none; a user unit started with graphical-session.target)
  home-manager.users.demiurge.services.hyprpolkitagent.enable = true;
}
