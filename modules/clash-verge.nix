# Proxy client: Clash Verge Rev (mihomo core, the same config format as OpenClash), autostarted at login.
# TUN mode goes through the service (clash-verge.service runs clash-verge-service as root); reverse path filtering is loose.
{
  flake.modules.nixos.clash-verge = {
    programs.clash-verge = {
      enable = true; # package defaults to clash-verge-rev
      serviceMode = true;
      tunMode = true;
      autoStart = true;
    };

    # The service's state; profiles and settings live in ~/.local/share/io.github.clash-verge-rev.clash-verge-rev on @home.
    environment.persistence."/persist".directories = [ "/var/lib/clash-verge-service" ];
  };
}
