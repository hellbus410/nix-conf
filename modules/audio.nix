# Sound: PipeWire, with its ALSA and PulseAudio front ends.
{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true; # real-time scheduling for PipeWire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
