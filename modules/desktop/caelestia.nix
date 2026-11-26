# Caelestia Wayland shell: narrow UI font widths, qtengine/darkly theming, helper agents, and user unit.
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Maple Mono narrowed for UI text, where the default 600 width overflows buttons, tabs and the lock clock:
      # narrow (NR, 550) for most of it, slim (SL, 500) for Caelestia's headline. Widths are only in the v8 betas, so nixpkgs doesn't have them yet.
      mapleMonoWidth =
        width: hash:
        pkgs.fetchzip {
          name = "maple-mono-${width}-nf";
          url = "https://github.com/subframe7536/maple-font/releases/download/v8.0-beta.3/MapleMono${width}-NF.zip";
          stripRoot = false;
          inherit hash;
          postFetch = ''
            mkdir -p $out/share/fonts/truetype
            mv $out/*.ttf $out/share/fonts/truetype/
          '';
        };
    in
    lib.mkIf (config.desktop.shell == "caelestia") {
      fonts = {
        packages = [
          (mapleMonoWidth "NR" "sha256-5onLVWs80JD9j9qNbj6UkEaVH8j2e+8UHwldn4ewhv0=") # "Maple Mono NR NF": sans/serif and Caelestia's UI text
          (mapleMonoWidth "SL" "sha256-2G9WORNSQW6Ugm77S+AMQVmKenkDeL3hLBZXzlyoLI4=") # "Maple Mono SL NF": Caelestia's headline
        ];
        fontconfig.defaultFonts = {
          sansSerif = [
            "Maple Mono NR NF"
            "Maple Mono NF CN"
            "CaskaydiaCove Nerd Font"
          ];
          serif = [
            "Maple Mono NR NF"
            "Maple Mono NF CN"
            "CaskaydiaCove Nerd Font"
          ];
        };
      };

      # NetworkManager secret agent: asks for a Wi-Fi password when a profile has none or it's wrong (the shell has none)
      programs.nm-applet.enable = true;
      services.geoclue2.enable = true; # location for gammastep; NixOS runs the geoclue agent as a user unit

      # Symmetric with programs.noctalia.systemd: bound to graphical-session.target under UWSM,
      # with enableDefaultPath = false so spawned launcher apps inherit UWSM's session PATH.
      systemd.user.services.caelestia = {
        description = "Caelestia Wayland desktop shell";
        documentation = [ "https://github.com/caelestia-dots/shell" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];

        enableDefaultPath = false;

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.caelestia-shell} -n";
          Restart = "on-failure";
        };
      };
    };

  flake.modules.homeManager.desktop =
    {
      lib,
      osConfig,
      pkgs,
      ...
    }:
    lib.mkIf (osConfig.desktop.shell == "caelestia") {
      # ── Polkit agent ── (Caelestia has none; started with graphical-session.target)
      services.hyprpolkitagent.enable = true;

      home.packages = with pkgs; [
        caelestia-shell
        caelestia-cli
        gammastep # night light, started by Caelestia's execs.lua
        trash-cli # trash-empty, run by Caelestia's execs.lua
        # Qt themes (Caelestia writes ~/.config/qtengine/config.json; base.nix sets qt.enable)
        qtengine
        darkly
      ];
    };
}
