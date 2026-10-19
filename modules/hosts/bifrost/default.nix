# bifrost's entry in the flake. Its NixOS configuration still lives in hosts/bifrost
# until the split into features moves it here.
{ inputs, ... }:
{
  flake.nixosConfigurations.bifrost = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      inherit (inputs) self;
    };
    modules = [ ../../../hosts/bifrost ];
  };
}
