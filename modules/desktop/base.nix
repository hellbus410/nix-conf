# Shared graphical base: Hyprland + UWSM, portals, greetd, fonts, and desktop utilities.
# The active Wayland shell ("caelestia" or "noctalia") is selected via `desktop.shell`.
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.desktop.shell = lib.mkOption {
        type = lib.types.enum [
          "caelestia"
        ];
        default = "caelestia";
        description = "Wayland desktop shell to run alongside Hyprland.";
      };

      config = {
        # ── Hyprland ──
        programs.hyprland.enable = true; # session file, portal, wrappers
        programs.hyprland.withUWSM = true;
        xdg.portal.extraPortals = [
          pkgs.xdg-desktop-portal-gtk # everything Hyprland's portal lacks (settings, …)
          pkgs.xdg-desktop-portal-termfilechooser # file chooser: yazi in foot; config in chezmoi
        ];
        xdg.portal.config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ]; # same as Hyprland's own hyprland-portals.conf
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
            maple-mono.NF-CN # fallback for Japanese text (even if it's Chinese)
            nerd-fonts.caskaydia-cove # fallback for the rest
          ];
          fontconfig = {
            defaultFonts = {
              sansSerif = lib.mkDefault [
                "Maple Mono NF"
                "Maple Mono NF CN"
                "CaskaydiaCove Nerd Font"
              ];
              serif = lib.mkDefault [
                "Maple Mono NF"
                "Maple Mono NF CN"
                "CaskaydiaCove Nerd Font"
              ];
              monospace = [
                "Maple Mono NF"
                "Maple Mono NF CN"
                "CaskaydiaCove Nerd Font"
              ];
              emoji = [ "OpenMoji Color" ];
            };
          };
          enableDefaultPackages = true;
        };

        # ── Session & hardware services ──
        services.upower.enable = true;
        services.power-profiles-daemon.enable = true;
        hardware.i2c.enable = true; # external monitor brightness (ddcutil)
        services.gnome.gnome-keyring.enable = true; # secrets store for apps (gnome-keyring-daemon)
        services.gnome.gcr-ssh-agent.enable = false; # SSH keys come from 1Password's agent

        # ── Qt plugin resolution ──
        qt.enable = true; # adds per-user profiles to QT_PLUGIN_PATH
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      # ── GTK icon theme ──
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };

      # ── Shared desktop programs ──
      home.packages = with pkgs; [
        wl-clipboard
        cliphist
        glib # gsettings (cursor theme/size and dark-style schemas)
        nvtopPackages.full
        pwvucontrol
        foot
        nautilus
        pastel # colour picker
        proton-cli
      ];
    };
}
