# AI assistants.
{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      imports = [ inputs.hermes-agent.homeManagerModules.default ];

      home.packages = with pkgs; [
        claude-code
        fabric-ai
        python3Packages.huggingface-hub
        (llama-cpp.override { cudaSupport = true; })
      ];

      programs.hermes-agent = {
        enable = true;          # the hermes CLI on your PATH
        desktop.enable = true;  # the Electron application and a launcher
      };

    };
}
