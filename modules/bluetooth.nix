# Bluetooth: BlueZ, powered on at boot. Its state dir is persisted in the host's impermanence.nix for now.
{
  hardware.bluetooth = {
    enable = true; # TODO:check the board has it: rfkill list
    powerOnBoot = true;
  };
}
