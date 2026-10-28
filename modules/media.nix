# Images, video, music, documents to read. Default apps: ~/.config/mimeapps.list in chezmoi.
{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        swayimg
        mpv # video, single audio files
        rmpc # music: client for mpd (services.mpd below)
        zathura # pdf, epub, djvu
        spotify
      ];

      # music daemon; rmpc is the client. Music dir = XDG_MUSIC_DIR (~/.config/user-dirs.dirs)
      services.mpd = {
        enable = true;
        musicDirectory = "/home/demiurge/music";
        extraConfig = ''
          audio_output {
            type "pipewire"
            name "PipeWire"
          }
        '';
      };
    };
}
