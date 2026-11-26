# `nix fmt` formats the repository with nixfmt-tree.
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
