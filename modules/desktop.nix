# The graphical session: settings and programs; its config files are in chezmoi.
{
  flake.modules.nixos.desktop =
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
        # Pinned to uwsm: --remember-session stores the session's store path, which every rebuild changes.
        # F3 still picks another session for one login.
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop' --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      };
      environment.persistence."/persist".directories = [
        {
          directory = "/var/cache/tuigreet"; # --remember state; must belong to greeter
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
      ];

      # ── Fonts ──
      fonts = {
        packages = with pkgs; [
          openmoji-color
          maple-mono.NF
          maple-mono.NF-CN #  fallback for Japanese text (even if it's Chinese)
          nerd-fonts.caskaydia-cove # fallback for the rest
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

      # ── Services the Caelestia shell reads ──
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;
      hardware.i2c.enable = true; # external monitor brightness (ddcutil)

      # ── Services Caelestia's autostart (hypr/hyprland/execs.lua) expects ──
      services.gnome.gnome-keyring.enable = true; # secrets store for apps (gnome-keyring-daemon)
      services.geoclue2.enable = true; # location for gammastep; NixOS runs the geoclue agent as a user unit

      # ── Theming ── (Caelestia writes ~/.config/qtengine/config.json; these make it resolvable)
      qt.enable = true; # adds per-user profiles to QT_PLUGIN_PATH so qtengine and darkly load
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      # ── Theming ── (Papirus for GTK apps; Qt's side is the NixOS half's qt.enable)
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };

      # ── Polkit agent ── (the shell has none; a user unit started with graphical-session.target)
      services.hyprpolkitagent.enable = true;

      # ── Programs ──
      home.packages = with pkgs; [
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
    };
}
