{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          age
          sops
          ssh-to-age
          gitleaks
          pre-commit
          yq-go
          nixd
          nixfmt
          nixos-anywhere
          deadnix
          statix
        ];

        shellHook = ''
          if [ -d .git ] && [ ! -f .git/hooks/pre-commit ]; then
            pre-commit install >/dev/null
          fi
        '';
      };
    };
}
