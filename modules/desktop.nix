# The graphical session: settings and programs; its config files are in chezmoi.
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
      openmoji-color
      maple-mono.NF
      maple-mono.NF-CN #  fallback for Japanese text (even if it's Chinese)
      nerd-fonts.caskaydia-cove # fallback for the rest
      # for onlyoffice: fonts .docx/.xlsx/.pptx files ask for, so layouts match Word
      corefonts # Arial, Times New Roman, Courier New, Verdana, Georgia, Trebuchet MS, Impact 
      vista-fonts # Calibri, Cambria, Candara, Consolas, Constantia, Corbel
      paratype-pt-sans # PT Sans/Serif/Mono
      paratype-pt-serif
      paratype-pt-mono
      noto-fonts 
      roboto 
      open-sans
      lato
      liberation_ttf
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Maple Mono NF" "Maple Mono NF CN" "CaskaydiaCove Nerd Font" ];
        serif = [ "Maple Mono NF" "Maple Mono NF CN" "CaskaydiaCove Nerd Font" ];
        monospace = [ "Maple Mono NF" "Maple Mono NF CN" "CaskaydiaCove Nerd Font" ];
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

  # ── Phone: Valent (KDE Connect protocol) ── (opens TCP/UDP 1714-1764; uwsm runs its xdg autostart)
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
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

  # ── Programs ──
  home-manager.users.demiurge.home.packages = with pkgs; [
    caelestia-shell
    caelestia-cli
    wl-clipboard # wl-paste, run by Caelestia's execs.lua (clipboard history)
    cliphist # same
    glib # gsettings, run by Caelestia's execs.lua (GTK cursor theme and size)
    btop
    pwvucontrol
    gammastep # night light, started by Caelestia's execs.lua
    trash-cli # trash-empty, run by Caelestia's execs.lua
    kitty
    # themes (Papirus comes from gtk.iconTheme above)
    qtengine
    darkly
    hyprmod # hyprland GUI config tool
  ];
}
