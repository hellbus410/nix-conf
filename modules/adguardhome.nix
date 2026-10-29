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
          # DoH only: plain port 53 out of this LAN is dropped (UDP) or answered with fake IPs (TCP), and so is QUIC.
          # TODO: switch Quad9 and Yandex to h3:// once UDP 443 leaves the router.
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "[/ru/xn--p1ai/]https://common.dot.dns.yandex.net/dns-query" # .ru and .рф (punycode) to Yandex
            "[/ts.net/]100.100.100.100" # tailnet names to Tailscale's MagicDNS
            "[//]10.41.13.1" # bare LAN hostnames (helheimr) to the router
            "[/local/]10.41.13.1" # the domain the router's DHCP hands out
          ];
          # The same servers by IP, for when a hostname upstream fails
          fallback_dns = [
            "https://9.9.9.9/dns-query https://149.112.112.112/dns-query"
            "[/ru/xn--p1ai/]https://77.88.8.8/dns-query https://77.88.8.1/dns-query"
          ];
          # Resolves the upstreams' hostnames; DoH by IP, as plain bootstrap gets no answer here
          bootstrap_dns = [
            "https://9.9.9.9/dns-query"
            "https://149.112.112.112/dns-query"
            "https://77.88.8.8/dns-query"
            "https://77.88.8.1/dns-query"
          ];
          enable_dnssec = true; # sets the DO bit; Quad9 and Yandex do the validation
          # Reverse lookups (10.41.13.x → name) to the router as well
          use_private_ptr_resolvers = true;
          local_ptr_upstreams = [ "10.41.13.1" ];
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
