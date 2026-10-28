# Command-line tools for the user, on every host.
{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        chezmoi
        age
        sops
        yazi
        fzf
        zoxide
        starship
        fastfetch
        tealdeer
        lazyrsync
        pastel # colour picker
      ];

      # nix-direnv: NixOS-only, so Home Manager's; ~/.zshrc needs `eval "$(direnv hook zsh)"`.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
