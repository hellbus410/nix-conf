# Every installed program. Programs that come with a NixOS module live with their settings:
#   zsh → system.nix · hyprland, tuigreet, fcitx5, 1password, fonts → desktop.nix
{ inputs, pkgs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # ── System: only what root and a rescue session need ──
  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
    curl
    pciutils # lspci, pcilmr, setpci
    usbutils # lsusb, lsusb.py, usb-devices, usbhid-dump, usbreset
  ];

  # ── User: demiurge, the same on every machine ──
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.demiurge = {
      home.stateVersion = "26.11"; # initial ver

      home.packages = with pkgs; [
        # dotfiles
        chezmoi

        # security
        age

        # cli
        eza
        bat
        ripgrep
        superfile 

        # desktop
        caelestia-shell
        caelestia-cli
        wl-clipboard
        grim
        slurp
        btop
        cliphist
        pwvucontrol
        polkit_gnome

        # apps
        kitty
        qutebrowser
        brave-origin
        # TODO: zen browser (not in nixpkgs; community flake)
        spotify-player
        protonmail-desktop

        #notes
        obsidian

        # messanging
        vesktop
        telegram-desktop

        # AI stuff
        claude-code
        claude-monitor # TODO: try it
        
        # remote
        # tailscale TODO: will also need to enable service
        # TODO: client for RDP

        # games
        protonplus

      ];

      # nix-direnv: NixOS-only, so Home Manager's; ~/.zshrc needs `eval "$(direnv hook zsh)"`.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
