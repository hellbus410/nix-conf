# 1Password, system-level: setgid CLI wrapper, polkit policy.
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "demiurge" ];
  };
}
