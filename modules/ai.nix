# AI assistants.
{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      imports = [ inputs.hermes-agent.homeManagerModules.default ];

      home.packages = with pkgs; [
        claude-code
        python3Packages.huggingface-hub
        fabric-ai
      ];

      programs.hermes-agent = {
        enable = true;          # the hermes CLI on your PATH
        desktop.enable = true;  # the Electron application and a launcher
      };

      services.ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
      };
    };
}
