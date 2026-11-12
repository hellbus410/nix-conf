{
  flake.modules.nixos.periphery =
    { config, pkgs, ... }:
    {
      # Razer mouse: OpenRazer driver and daemon
      hardware.openrazer = {
        enable = true;
        users = [ config.user.name ];
      };

      # QMK keyboards udev rules
      hardware.keyboard.qmk.enable = true;

      # NuPhy keyboards WebHID udev rules (for nuphy.io and VIA)
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="19f5", MODE="0666", TAG+="uaccess"
        KERNEL=="hidraw*", ATTRS{idVendor}=="19f5", MODE="0666", TAG+="uaccess"
      '';
    };

  flake.modules.homeManager.periphery =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        razergenie
      ];
    };
}
