# AI assistants.
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        claude-code
        python3Packages.huggingface-hub
        fabric-ai
      ];

      

      services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
      };
    };
}
