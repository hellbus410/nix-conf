# The graphical session: settings only — its programs are in packages.nix, its config files in chezmoi.
{ config, pkgs, ... }:
{
  # ── Hyprland ──
  programs.hyprland.enable = true; # session file, portal, polkit, wrappers
  programs.hyprland.withUWSM = true; # OPEN: uwsm or plain
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk # everything Hyprland's portal lacks (settings, …)
    pkgs.xdg-desktop-portal-termfilechooser # file chooser: yazi in kitty; config in chezmoi
  ];
  xdg.portal.config.hyprland = {
    default = [ "hyprland" "gtk" ]; # same as Hyprland's own hyprland-portals.conf
    "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };
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
    enableDefaultPackages = true;
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

  # ── Services Caelestia's autostart (hypr/hyprland/execs.lua) expects ──
  services.gnome.gnome-keyring.enable = true; # secrets store for apps (gnome-keyring-daemon)
  services.geoclue2.enable = true; # location for gammastep; NixOS runs the geoclue agent as a user unit

  # ── Theming ── (Caelestia writes ~/.config/qtengine/config.json; these make it resolvable)
  qt.enable = true; # adds per-user profiles to QT_PLUGIN_PATH so qtengine and darkly load
  home-manager.users.demiurge.gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # ── Polkit agent ── (the shell has none; a user unit started with graphical-session.target)
  home-manager.users.demiurge.services.hyprpolkitagent.enable = true;

  # ── Games ──
  programs.steam.enable = true;
}
