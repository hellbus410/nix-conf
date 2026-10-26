# AI assistants.
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        claude-code
        herdr # TODO: try claude-code using herdr
      ];
    };
}
