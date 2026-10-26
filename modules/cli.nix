# Command-line tools for the user, on every host.
{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # dotfiles
        chezmoi

        # security
        age

        # secrets
        sops # with age

        # cli
        eza
        bat
        ripgrep
        yazi
        fd
        fzf
        zoxide
        starship
        fastfetch
        jq
        yq-go # `yq`, the Go one (jq-like syntax, edits YAML in place)
        sd
        entr
        file
        tree
        dysk # disk usage per filesystem (df)
        tealdeer # `tldr`
        lsof
        psmisc # killall, pstree, fuser
        wget
        unzip
        zip
        _7zz
        lazyrsync # TUI for rsync
        pastel # colour picker
        zeitgeist # zeit - activity log

        # git
        delta # diff pager; set in ~/.config/git/config
        lazygit

        # network
        openssl
        dnsutils # dig, nslookup
        nmap
        whois

        # remote
        # tailscale TODO: will also need to enable service
        # TODO: client for RDP
      ];

      # nix-direnv: NixOS-only, so Home Manager's; ~/.zshrc needs `eval "$(direnv hook zsh)"`.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
