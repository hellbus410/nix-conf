# AI assistants.
{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { osConfig, pkgs, ... }:
    let
      hasNvidia = builtins.elem "nvidia" (osConfig.services.xserver.videoDrivers or [ ]);
    in
    {
      imports = [ inputs.hermes-agent.homeManagerModules.default ];

      home.packages = with pkgs; [
        claude-code
        antigravity-cli
        fabric-ai
        python3Packages.huggingface-hub
        (
          if hasNvidia then
            llama-cpp.override { cudaSupport = true; }
          else
            llama-cpp.override { vulkanSupport = true; }
        )
      ];

      programs.hermes-agent = {
        enable = true; # the hermes CLI on your PATH
        desktop.enable = true; # the Electron application and a launcher
      };

    };
}
