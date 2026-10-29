# DNS ad blocking: AdGuard Home on localhost is the system resolver; settings are declared here, the web UI is read-only in effect.
# Upstream is DNS over HTTPS by IP: the router intercepts plain port 53 (v2rayA, fake IPs) but not TLS.
{
  flake.modules.nixos.adguardhome = {
    services.adguardhome = {
      enable = true;
      mutableSettings = false; # changes made in the web UI are dropped on restart
      settings = {
        http.address = "127.0.0.1:3000";
        dns = {
          bind_hosts = [ "127.0.0.1" "::1" ];
          port = 53;
          upstream_dns = [
            "https://1.1.1.1/dns-query"
            "https://1.0.0.1/dns-query"
            "[/ts.net/]100.100.100.100" # tailnet names to Tailscale's MagicDNS
          ];
          bootstrap_dns = [ "1.1.1.1" ]; # unused with IP upstreams, but the module asserts a list
        };
        filters = [
          {
            enabled = true;
            id = 1;
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          }
        ];
      };
    };

    # resolv.conf points at AdGuard Home only; NetworkManager stops writing the DHCP servers into it.
    networking.nameservers = [ "127.0.0.1" "::1" ];
    networking.networkmanager.dns = "none";

    # Query log, stats and downloaded filters; DynamicUser keeps them under /var/lib/private, which must stay 0700.
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };
}
