# `nix fmt` formats the repository with nixfmt.
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;
    };
}
