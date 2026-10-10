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
        fd
        fzf # shell keys (Ctrl-R, Ctrl-T) to be hooked up in ~/.zshrc
        zoxide # `z`, to be hooked up in ~/.zshrc
        jq
        yq-go # `yq`, the Go one (jq-like syntax, edits YAML in place)
        sd # find & replace, simpler than sed
        entr # rerun a command when files change
        file
        tree
        dysk # disk usage per filesystem (df)
        tealdeer # `tldr`
        lsof
        psmisc # killall, pstree, fuser
        wget
        unzip
        zip
        _7zz # `7zz`
        lazyrsync # TUI for rsync

        # git
        delta # diff pager; set in ~/.config/git/config
        gh

        # network
        openssl
        dnsutils # dig, nslookup
        nmap
        whois

        # secrets
        sops # with age

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

        # media (default apps: ~/.config/mimeapps.list in chezmoi)
        swayimg # images
        mpv # video, single audio files
        rmpc # music: client for mpd (services.mpd below)
        zathura # pdf, epub, djvu

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

      # music daemon; rmpc is the client. Music dir = XDG_MUSIC_DIR (~/.config/user-dirs.dirs)
      services.mpd = {
        enable = true;
        musicDirectory = "/home/demiurge/music";
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "PipeWire"
          }
        '';
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
