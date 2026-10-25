# Bluetooth: BlueZ, powered on at boot.
{
  hardware.bluetooth = {
    enable = true; # TODO:check the board has it: rfkill list
    powerOnBoot = true;
  };

  environment.persistence."/persist".directories = [ "/var/lib/bluetooth" ]; # pairings
}
