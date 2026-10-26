# mkHost: every `hosts.<name>` becomes `nixosConfigurations.<name>`. A feature name brings in
# `flake.modules.nixos.<name>` for the system and `flake.modules.homeManager.<name>` for the user,
# whichever of the two the feature has; a name with neither stops the evaluation.
{ config, inputs, lib, ... }:
let
  inherit (config.flake.modules) nixos homeManager;

  mkHost =
    name: host:
    let
      unknown = lib.filter (f: !(nixos ? ${f} || homeManager ? ${f})) host.features;
      # Both halves of a feature, side by side; the order of the features is the order of list entries.
      halves =
        f:
        lib.optional (nixos ? ${f}) nixos.${f}
        ++ lib.optional (homeManager ? ${f}) (
          { config, ... }:
          {
            home-manager.users.${config.user.name} = homeManager.${f};
          }
        );
    in
    assert lib.assertMsg (unknown == [ ]) "host ${name}: no feature named ${toString unknown}";
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        host.module # first, so the host's own list entries come before the features'
        { networking.hostName = name; }
        # The one login account; a host may rename it. Features read it as config.user.name.
        {
          options.user.name = lib.mkOption {
            type = lib.types.str;
            default = "demiurge";
            description = "Name of the main user account, and of its Home Manager configuration.";
          };
        }
      ]
      ++ lib.concatMap halves host.features;
    };
in
{
  options.hosts = lib.mkOption {
    description = "Machines: the features each one lists, and what is its own (hardware, disk id, stateVersion).";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          features = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Feature names, in order; usually a role plus the host's extras.";
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
            description = "The host's own NixOS configuration.";
          };
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs mkHost config.hosts;
}
