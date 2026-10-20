# Images, video, music, documents to read. Default apps: ~/.config/mimeapps.list in chezmoi.
{ pkgs, ... }:
{
  home-manager.users.demiurge = {
    home.packages = with pkgs; [
      swayimg
      mpv # video, single audio files
      rmpc # music: client for mpd (services.mpd below)
      zathura # pdf, epub, djvu
      spotify
      spotify-player
      ncspot
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
