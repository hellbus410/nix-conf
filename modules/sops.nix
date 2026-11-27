# Encrypted secrets via sops-nix: host SSH Ed25519 key unwraps age recipients into ramfs (/run/secrets).
{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = ../secrets/common.yaml;

        # neededForUsers runs in early stage-2 before impermanence bind-mounts /etc/ssh;
        # read the persisted host key directly from /persist when impermanence is active.
        age.sshKeyPaths =
          if config.environment.persistence."/persist".enable then
            [ "/persist/etc/ssh/ssh_host_ed25519_key" ]
          else
            [ "/etc/ssh/ssh_host_ed25519_key" ];

        # Only age/Ed25519 is used; skip default RSA -> GPG host key conversion (and missing /etc/ssh/ssh_host_rsa_key before bind-mount).
        gnupg.sshKeyPaths = [ ];

        secrets."passwords/${config.user.name}" = {
          neededForUsers = true;
        };
      };

      users.mutableUsers = false;
      users.users.${config.user.name}.hashedPasswordFile =
        config.sops.secrets."passwords/${config.user.name}".path;
    };
}
