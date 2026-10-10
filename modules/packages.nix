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
      imports = [ inputs.zen-browser.homeModules.beta ];
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
        yazi 

        # neovim: language servers enabled in ~/.config/nvim/init.lua (skipped there when missing)
        nixd
        bash-language-server
        ansible-language-server
        yaml-language-server
        dockerfile-language-server
        docker-compose-language-service
        helm-ls
        tofu-ls
        lua-language-server
        marksman
        taplo
        vscode-langservers-extracted # vscode-json-language-server
        systemd-lsp
        # nvim-treesitter (main) compiles parsers with these
        tree-sitter
        gcc

        # desktop
        caelestia-shell
        caelestia-cli
        wl-clipboard # wl-paste, run by Caelestia's execs.lua (clipboard history)
        cliphist # same
        glib # gsettings, run by Caelestia's execs.lua (GTK cursor theme and size)
        btop
        pwvucontrol
        gammastep # night light, started by Caelestia's execs.lua
        trash-cli # trash-empty, run by Caelestia's execs.lua
        # themes (Papirus comes from gtk.iconTheme in desktop.nix)
        qtengine
        darkly

        # apps
        kitty
        qutebrowser
        brave-origin
        spotify
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

      programs.zen-browser = {
        enable = true;
        # Firefox uses its own GTK dialog outside Flatpak; 1 = always ask the portal (yazi)
        policies.Preferences."widget.use-xdg-desktop-portal.file-picker" = {
          Value = 1;
          Status = "locked";
        };
      };
    };
  };
}
