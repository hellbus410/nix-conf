# Tailscale: reaching the homelab from outside it. Logged in once by hand (`sudo tailscale up`); the node key survives in /persist.
# Tailscale leaves resolv.conf alone: AdGuard Home is the resolver and forwards ts.net to MagicDNS.
{
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      openFirewall = true; # UDP 41641, for direct connections instead of DERP relays
      extraSetFlags = [ "--accept-dns=false" ];
    };

    environment.persistence."/persist".directories = [ "/var/lib/tailscale" ];
  };
}
