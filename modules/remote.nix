# Clients for remote connection
{
  flake.modules.homeManager.remote = 
    { pkgs, ...}:
  {
    home.packages = with pkgs; [
      freerdp # wlfreerdp
      moonlight-qt # pair with sunshine to connect
      rustdesk-flutter # analog of teamviewer/anydesk
    ];
  };
}
