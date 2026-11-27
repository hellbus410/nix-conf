# Command-line tools for the user, on every host.
{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        chezmoi
        age
        ssh-to-age
        sops
        jq
        yq-go
        atuin
        yazi
        fzf
        zoxide
        starship
        fastfetch
        tealdeer
        lazyrsync
      ];
    };
}
