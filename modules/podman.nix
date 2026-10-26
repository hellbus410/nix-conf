# Containers: Podman, run rootless by $USER.
{
  virtualisation.podman.enable = true;

  # Rootful storage, for `sudo podman`; rootless images and containers live under ~/.local/share/containers on @home.
  environment.persistence."/persist".directories = [ "/var/lib/containers" ];
}
