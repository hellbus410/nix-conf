# 1Password, workstation-only: setgid CLI/browser wrappers, polkit policy, allowed browsers, and SSH agent socket.
{
  flake.modules.nixos."1password" =
    { config, ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ config.user.name ];
      };

      # Additive allowlist for 1Password-BrowserSupport native messaging (Zen Browser and Brave Origin).
      environment.etc."1password/custom_allowed_browsers" = {
        text = ''
          zen
          zen-beta
          .zen-beta-wrapped
          brave
          brave-origin
        '';
        mode = "0644";
      };

      # Exposes the 1Password SSH agent to tools that read SSH_AUTH_SOCK directly (ssh-add, Ansible, Go/Python clients).
      # Scoped to 1password.nix so headless servers never clobber forwarded SSH agent sockets.
      environment.sessionVariables.SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    };
}
