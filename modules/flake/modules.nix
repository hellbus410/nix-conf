# The option `flake.modules.<class>.<name>`: each feature file puts its NixOS half under
# `nixos.<name>` and its Home Manager half under `homeManager.<name>`.
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
