# 1Password, system-level: setgid CLI wrapper, polkit policy.
{
  flake.modules.nixos."1password" = {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "demiurge" ];
    };
  };
}
