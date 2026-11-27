# Search: SearXNG on http://127.0.0.1:8888, for this machine only (no limiter, so no Valkey).
# SEARX_SECRET_KEY=<key> comes from sops-nix (searx_env in secrets/common.yaml).
{
  flake.modules.nixos.searxng =
    { config, ... }:
    {
      sops.secrets.searx_env = {
        restartUnits = [
          "searx-init.service"
          "searx.service"
        ];
      };

      services.searx = {
        enable = true;
        environmentFile = config.sops.secrets.searx_env.path;
        settings.server = {
          bind_address = "127.0.0.1";
          port = 8888;
          secret_key = "$SEARX_SECRET_KEY"; # filled in by envsubst in searx-init.service
        };
      };

      # SearXNG checks the network once at start and exits if DNS isn't answering yet; start after the resolver and retry.
      systemd.services.searx = {
        wants = [ "adguardhome.service" ];
        after = [ "adguardhome.service" ];
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
