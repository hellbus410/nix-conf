# Workstation development tools: GitHub CLIs, direnv, and global Doom Emacs language servers/formatters.
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      home.packages = with pkgs; [
        # github
        gh
        ghgrab
        gh-dash

        # doom emacs: global language servers, formatters, and grammar compiler
        nixd
        bash-language-server
        ansible-language-server
        yaml-language-server
        dockerfile-language-server
        docker-compose-language-service
        helm-ls
        tofu-ls
        lua-language-server
        marksman
        taplo
        vscode-langservers-extracted # vscode-json-language-server
        pandoc
        nixfmt
        shellcheck
        gcc

        # others
        entr

        # devops: kubernetes & gitops
        kubectl
        kubernetes-helm
        kustomize
        k9s
        kubectx
        stern
        cilium-cli
        fluxcd
        argocd

        # devops: iac & automation
        ansible
        ansible-lint
        opentofu
        terraform
        terragrunt
        tflint

        # devops: containers & ci
        podman-compose
        skopeo
        dive
        act

        # databases
        postgresql
      ];
    };
}
