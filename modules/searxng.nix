# Search: SearXNG on http://127.0.0.1:8888, for this machine only (no limiter, so no Valkey).
# The secret key is outside the store: /persist/secrets/searx.env holds SEARX_SECRET_KEY=<key>.
{
  flake.modules.nixos.searxng = {
    services.searx = {
      enable = true;
      environmentFile = "/persist/secrets/searx.env";
      settings.server = {
        bind_address = "127.0.0.1";
        port = 8888;
        secret_key = "$SEARX_SECRET_KEY"; # filled in by envsubst from environmentFile
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
