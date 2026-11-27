# Workstation development tools: GitHub CLIs, direnv, and global Doom Emacs language servers/formatters.
# Project-specific IaC, Kubernetes, and database toolchains live in per-repository flake devShells.
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      home.packages = with pkgs; [
        # github
        gh
        ghgrab
        gh-dash

        # doom emacs: global language servers, formatters, and grammar compiler
        nixd
        nixfmt
        bash-language-server
        shellcheck
        shfmt
        yaml-language-server
        dockerfile-language-server
        docker-compose-language-service
        lua-language-server
        marksman
        pandoc
        taplo
        vscode-langservers-extracted # vscode-json-language-server
        gcc # treesit-auto-install-grammar compiles tree-sitter .so grammars with cc/gcc

        # others
        entr

        # containers & ci
        podman-compose
        skopeo
        dive
        act
      ];
    };
}
